local ESX = exports['qb-core']:GetCoreObject()
local QBCore = exports['qb-core']:GetCoreObject()

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- variables --
police         = GetHashKey('police3')
police2        = GetHashKey('fbi')
policeman      = GetHashKey("s_m_y_cop_01")
policeman2     = GetHashKey("s_m_y_swat_01")
companyName    = "Dispatch"
companyIcon    = "CHAR_CALL911"
drivingStyle   = 787004 -- https://www.vespura.com/fivem/drivingstyle/
playerSpawned  = false
active         = false
arrived        = false
vehicle        = nil
driver_ped     = nil
passenger_ped  = nil
vehBlip        = nil
playerSpawned  = true


-- spawning events --
RegisterNetEvent('POL:Spawn')


-- command --

RegisterCommand("LSPD-Backup", function(source, args, raw)
    local Player = QBCore.Functions.GetPlayerData()
    local jobName = Player.job.name
    if jobName == 'police' then 
        QBCore.Functions.Notify('LSPD: BACKUP INCOMING', 'success', 4000)
        TriggerEvent('POL:Spawn')
    else
        QBCore.Functions.Notify('LSPD: POLICE ONLY', 'error', 4000)
    end
end)

RegisterCommand("LSPD-Follow", function()
	local player = PlayerPedId()
	if player~=nil and active then
		Follow()
	end
end, false)

RegisterCommand("LSPD-Clear", function()
        local player = PlayerPedId()
        LeaveScene()
end, false)

RegisterCommand("LSPD-Out", function()
    local player = PlayerPedId()
    LeaveVehicle()
end, false)

RegisterCommand("LSPD-GroupID", function(source, args, raw)
    local playerGroupId = GetPedGroupIndex(player)
    QBCore.Functions.Notify(playerGroupId, 'success', 4000)
end)


-- functions --
function EnterVehicle()
    if vehicle ~= nil then
        TaskEnterVehicle(driver_ped, vehicle, 2000, -1, 20, 1, 0)
        while GetIsTaskActive(driver_ped, 160) do
            Wait(1)
        end
        TaskEnterVehicle(passenger_ped, vehicle, 2000, 0, 20, 1, 0)
        while GetIsTaskActive(passenger_ped, 160) do
            Wait(1)
        end      
    end
end

function LeaveVehicle()
    if vehicle ~= nil then
        ClearPedTasks(driver_ped)
        TaskLeaveVehicle(driver_ped, vehicle, 0)
        while IsPedInAnyVehicle(driver_ped, false) do
            Wait(1)
        end
        ClearPedTasks(passenger_ped)
        TaskLeaveVehicle(passenger_ped, vehicle, 0)
        while IsPedInAnyVehicle(passenger_ped, false) do
            Wait(1)
        end	
    end
end

function LeaveScene()
    if active then
        QBCore.Functions.Notify('LSPD: BACKUP CLEARED', 'success', 4000) 
        EnterVehicle()
        TaskVehicleDriveWander(driver_ped, vehicle, 17.0, 262315)
        SetEntityAsNoLongerNeeded(vehicle)
        SetPedAsNoLongerNeeded(driver_ped)
        SetPedAsNoLongerNeeded(passenger_ped)
        SetVehicleSiren(vehicle, false)
        RemoveBlip(vehBlip)
        -- reset --
        active        = false
        arrived       = false
    end
end

function Follow()
        QBCore.Functions.Notify('LSPD: FOLLOWING', 'success', 4000) 	
		local player = GetPlayerPed(source) --Player
		local playerGroupId = GetPedGroupIndex(player)
        SetPedAsGroupMember(driver_ped, -1) 
        SetPedAsGroupMember(passenger_ped, -1)
end


-- spawning events handlers --  LSPD-AI1
AddEventHandler('POL:Spawn', function(player)
    if not active then
        if player == nil then
            player = PlayerPedId()
        end

        Citizen.CreateThread(function()
            active = true
            local pc = GetEntityCoords(player)

            RequestModel(policeman)
            while not HasModelLoaded(policeman) do
                RequestModel(policeman)
                Citizen.Wait(1)
            end

            RequestModel(police)
            while not HasModelLoaded(police) do
                RequestModel(police)
                Citizen.Wait(1)
            end            

            local offset = GetOffsetFromEntityInWorldCoords(player, 100, 100, 0)
            local heading, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x+100, offset.y+100, offset.z, pc.x, pc.y, pc.z, 16, 1, 0x40400000, 0)

            vehicle         = CreateVehicle(police, spawn.x, spawn.y, spawn.z, heading, true, true)
            driver_ped      = CreatePedInsideVehicle(vehicle, 6, policeman, -1, true, true)
            passenger_ped   = CreatePedInsideVehicle(vehicle, 6, policeman, 0, true, true)

            SetEntityAsMissionEntity(vehicle)
            SetEntityAsMissionEntity(driver_ped)
            SetEntityAsMissionEntity(passenger_ped)        
            
            SetModelAsNoLongerNeeded(police)
            SetModelAsNoLongerNeeded(policeman)            

            GiveWeaponToPed(driver_ped, GetHashKey("weapon_specialcarbine"), math.random(20, 300), false, true) -- Fahrer/Driver/YYY
            GiveWeaponToPed(passenger_ped, GetHashKey("WEAPON_PUMPSHOTGUN"), math.random(20, 300), false, true) -- Beifahrer/Passenger/XXX

            LoadAllPathNodes(true)
            while not AreAllNavmeshRegionsLoaded() do
                Wait(1)
            end   

            -- AI BACKUP Settings --
            local playerGroupId = GetPedGroupIndex(player)
            SetPedAsGroupMember(driver_ped, playerGroupId) -- Fahrer/Driver/YYY
            SetPedAsGroupMember(passenger_ped, playerGroupId) -- Beifahrer/Passenger/XXX

            NetworkRequestControlOfEntity(driver_ped) -- Fahrer/Driver/YYY
            NetworkRequestControlOfEntity(passenger_ped) -- Beifahrer/Passenger/XXX

            ClearPedTasksImmediately(driver_ped) -- Fahrer/Driver/YYY
            ClearPedTasksImmediately(passenger_ped) -- Beifahrer/Passenger/XXX
            
       --     local _, relHash = AddRelationshipGroup("POL8")
       --     SetPedRelationshipGroupHash(driver_ped, relHash)
       --     SetPedRelationshipGroupHash(passenger_ped, relHash)        
       --     SetRelationshipBetweenGroups(0, relHash, GetHashKey("PLAYER"))
       --     SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), relHash)

            vehBlip = AddBlipForEntity(vehicle)
            SetBlipSprite(vehBlip,41)

            SetVehicleSiren(vehicle, true)
            EnterVehicle()
            TaskVehicleDriveToCoordLongrange(driver_ped, vehicle, pc.x, pc.y, pc.z, 16.0, drivingStyle, 10.0)
            arrived = false
            while not arrived do
                Citizen.Wait(0)
                local coords = GetEntityCoords(vehicle)
                local distance = #(coords - pc) -- faster than Vdist
                if distance < 10.0 then
                    arrived = true
                end
            end
            while GetEntitySpeed(vehicle) > 0 do
                Wait(1)
            end 
            LeaveVehicle()
            QBCore.Functions.Notify('LSPD: BACKUP ARRIVED', 'success', 4000)
            Wait(6000)
            Follow()
        end)
    else 
        QBCore.Functions.Notify('LSPD: BACKUP ENGAGED', 'success', 4000) 
    end
end)