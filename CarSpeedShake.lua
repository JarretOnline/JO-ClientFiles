local isDriving = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId(-1)
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            local speed = GetEntitySpeed(vehicle) * 3.6
            
            if DoesEntityExist(vehicle) then
                if speed >= 16 and not isDriving then
                    isDriving = true
                    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.20)
                    Citizen.Wait(600)
                    StopGameplayCamShaking(0)
                elseif speed >= 180 and isDriving then
                    isDriving = true
                    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.60)
                    Citizen.Wait(500)
                    StopGameplayCamShaking(0)
                elseif speed >= 240 and isDriving then
                    isDriving = true
                    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.90)
                    Citizen.Wait(500)
                    StopGameplayCamShaking(0)
                elseif speed >= 300 and isDriving then
                    isDriving = true
                    ShakeGameplayCam('SKY_DIVING_SHAKE', 1.20)
                    Citizen.Wait(500)
                    StopGameplayCamShaking(0)
                elseif speed >= 340 and isDriving then
                    isDriving = true
                    ShakeGameplayCam('SKY_DIVING_SHAKE', 1.80)
                    Citizen.Wait(500)
                    StopGameplayCamShaking(0)
                elseif speed <= 2 then
                    isDriving = false
                end
            end
        end
    end
end)

--Pretty simple huh?