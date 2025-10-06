RegisterNetEvent('fearx-notify:server:send', function(target, ntype, title, message, duration, count, opts)
    if target == -1 or target == 0 or target == nil then
        TriggerClientEvent('fearx-notify:client:send', -1, ntype, title, message, duration, count, opts)
    else
        TriggerClientEvent('fearx-notify:client:send', target, ntype, title, message, duration, count, opts)
    end
end)

exports('Send', function(target, ntype, title, message, duration, count, opts)
    if target == nil then target = -1 end
    TriggerEvent('fearx-notify:server:send', target, ntype, title, message, duration, count, opts)
end)

RegisterNetEvent('fearx-notify:server:playerDied', function(killerId, victimRolling)
    local src = source
    if not killerId or tonumber(killerId) == nil then return end
    local killer = tonumber(killerId)
    if not GetPlayerName(killer) then return end
    local victimName = GetPlayerName(src) or ('ID %s'):format(src)
    local killerName = GetPlayerName(killer) or ('ID %s'):format(killer)
    TriggerClientEvent('fearx-notify:client:send', killer, 'kill', 'You Killed', ('%s (%s)'):format(victimName, src), 5000)
    TriggerClientEvent('fearx-notify:client:send', src, 'killed', 'Killed By', ('%s (%s)'):format(killerName, killer), 5000)
    if victimRolling then
        TriggerClientEvent('fearx-notify:client:send', killer, 'info', 'Midrolled', ('You midrolled (%s)'):format(src), 4000, nil, { barHex = '#ef4444' })
        TriggerClientEvent('fearx-notify:client:send', src, 'info', 'Midrolled', ('You got midrolled by (%s)'):format(killer), 4000, nil, { barHex = '#ef4444' })
    end
end)
