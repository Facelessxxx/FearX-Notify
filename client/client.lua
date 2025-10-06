local function send(data)
    SendNUIMessage(data)
end

local OriginalESXShow

local function mapType(t)
    if not t then return 'info' end
    if t == 'main' or t == 'inform' or t == 'info' then return 'info' end
    if t == 'success' then return 'success' end
    if t == 'error' or t == 'danger' then return 'error' end
    return tostring(t)
end

local function notify(ntype, title, message, duration, count, opts)
    if Config and Config.GlobalMute then return end
    local t = mapType(ntype or (Config and Config.DeaultNotify) or 'info')
    if Config and Config.EsxNotifcation and ESX and OriginalESXShow then
        OriginalESXShow(message or '', t, duration or 5000)
        return
    end
    local pos = (Config and Config.Position) or 'top-right'
    local cfg = (Config and Config.Notifications and Config.Notifications[t]) or (Config and Config.Notifications and Config.Notifications[Config.DeaultNotify]) or nil
    local d = {
        action = 'fearx_notify',
        type = t,
        title = title or (cfg and cfg.title) or '',
        message = message or '',
        duration = duration or 5000,
        count = count,
        position = pos
    }
    if cfg then
        d.icon = (opts and opts.icon) or cfg.icon
        d.barHex = (opts and (opts.barHex or opts.color)) or cfg.color
        if not (cfg.mute) and cfg.sound and cfg.sound ~= '' then
            d.sound = cfg.sound
            d.volume = cfg.volume or '0.3'
        end
    else
        if opts then
            d.icon = opts.icon
            d.barHex = opts.barHex or opts.color
        end
    end
    if opts then
        for k, v in pairs(opts) do
            if d[k] == nil then d[k] = v end
        end
    end
    send(d)
end

exports('Send', function(ntype, title, message, duration, count, opts)
    notify(ntype, title, message, duration, count, opts)
end)

RegisterNetEvent('fearx-notify:client:send', function(ntype, title, message, duration, count, opts)
    notify(ntype, title, message, duration, count, opts)
end)

if Config and Config.Debug then
    RegisterCommand('notify', function(source, args)
        local t = args[1]
        if not t or t == '' then t = Config.DeaultNotify or 'info' end
        local msg = table.concat(args, ' ', 2)
        if msg == '' then msg = ('Testing %s'):format(t) end
        notify(t, nil, msg, 5000)
    end)
end

CreateThread(function()
    local waited = 0
    while waited < 200 do
        if ESX ~= nil then break end
        Wait(50)
        waited = waited + 1
    end
    if ESX and type(ESX) == 'table' then
        OriginalESXShow = ESX.ShowNotification
        ESX.ShowNotification = function(message, type_, length, custom_icon)
            local ntype = mapType(type_)
            if Config and Config.EsxNotifcation and OriginalESXShow then
                return OriginalESXShow(message, ntype, length)
            end
            local opts = {}
            if custom_icon then opts.icon = custom_icon end
            notify(ntype, nil, message or '', length or 4500, nil, opts)
        end
    end
end)

RegisterCommand('notify', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'fearx_notify_settings_open' })
end)

RegisterNUICallback('fearx_notify_settings_save', function(data, cb)
    SetNuiFocus(false, false)
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('fearx_notify_settings_close', function(data, cb)
    SetNuiFocus(false, false)
    if cb then cb({ ok = true }) end
end)

CreateThread(function()
    local waited = 0
    while waited < 200 do
        if lib ~= nil then break end
        Wait(50)
        waited = waited + 1
    end
    if lib and type(lib) == 'table' then
        local original = lib.notify
        lib.notify = function(data)
            if not data then return end
            local t = mapType(data.type)
            local duration = data.duration or 5000
            notify(t, data.title, data.description or data.message or '', duration, nil, { icon = data.icon, color = data.color, position = data.position })
        end
    end
end)

RegisterCommand('fxn_success', function()
    notify('success', 'Success', 'Vehicle successfully stored.', 5000)
end)

RegisterCommand('fxn_error', function()
    notify('error', 'Error', 'Not enough cash on hand.', 5000)
end)

RegisterCommand('fxn_kill', function()
    notify('kill', 'You Killed', 'Random Player', 5000, 45)
end)

RegisterCommand('fxn_killed', function()
    notify('killed', 'Killed By', 'Pharoah 528i', 5000, 32)
end)

RegisterCommand('fxn_custom', function()
    notify('custom', 'Hello', 'Custom message', 7000, nil, { icon = 'https://r2.fivemanage.com/reN0iza3vc4oGjJ0nDgay/DcLogo.png', barColor = 'bg-blue-500' })
end)
