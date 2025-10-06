local lastRollAt = 0
local wasDead = false

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPlayerFreeAiming(PlayerId()) and IsPedOnFoot(ped) then
            if IsControlJustPressed(0, 22) then
                lastRollAt = GetGameTimer()
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local dead = IsEntityDead(ped)
        if dead and not wasDead then
            local killer = GetPedSourceOfDeath(ped)
            if killer and IsEntityAPed(killer) and IsPedAPlayer(killer) then
                local killerPlayer = NetworkGetPlayerIndexFromPed(killer)
                if killerPlayer ~= -1 then
                    local killerServerId = GetPlayerServerId(killerPlayer)
                    local victimRolling = (GetGameTimer() - lastRollAt) <= 1200
                    TriggerServerEvent('fearx-notify:server:playerDied', killerServerId, victimRolling)
                end
            end
            wasDead = true
        elseif not dead and wasDead then
            wasDead = false
        end
        Wait(200)
    end
end)

