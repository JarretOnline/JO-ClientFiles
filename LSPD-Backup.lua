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
local Stations = {
vector3(616.28, 27.49, 88.89), --Vinewood
vector3(407.2,-997.7,28.87), -- MissionRow
vector3(-954.13,-1286.5,4.63), -- HQ
vector3(-1811.19,-337.28,43.15), -- HQ2
vector3(-699.24,312.21,82.58), -- HQ3
vector3(-645.01,-107.17,37.46), -- HQ4
vector3(345.83,-1474.58,28.53), -- Medical
vector3(-914.77,-2062.43,8.89), -- Crastenburg
vector3(56.73,-2660.74,5.62), -- OnesideOfDocks
vector3(1646.34,-2276.93,105.58), -- Industry
vector3(2575.28,327.15,108.07), -- RonStation
vector3(1854.79,2627.39,45.29), -- Pen
vector3(424.2,3542.9,33.05), -- gasStationSandy
vector3(1842.83,3706.64,33.2), -- SandyPoliceStation
vector3(2551.58,4687.11,33.35), -- SandySideRoad
vector3(-449.02,6035.93,30.96), -- PaletStation
vector3(-2324.43,3440.61,31.01), -- military 
}
local StationsHeading = {
10.29, --Vinewood
53.62, -- MissionRow
303.81, -- HQ
317.34, -- HQ2
175.33, -- HQ3
118.63, -- HQ4
210.69, -- medical
224.65, -- Crastenburg
5.59, -- OnesideOfDocks
241.02, -- Industry
0.89, -- RonStation
270, -- Pen
93.23, --gasStationSandy
25.73, --SandyPoliceStation
49.19, --SandySideRoad
311.81, --PaletStation
113.09, --military
}


-- variables --
isCancelled    = false
police         = GetHashKey('police3')
police2        = GetHashKey('fbi')
policeman      = GetHashKey("s_m_y_cop_01")
policeman2     = GetHashKey("s_m_y_swat_01")
companyName    = "Dispatch"
companyIcon    = "CHAR_CALL911"
drivingStyle   = 787004 -- https://www.vespura.com/fivem/drivingstyle/
localPlayerGroup = -1
active         = false
arrived        = false
vehicle        = nil
driver_ped     = nil
passenger_ped  = nil
vehBlip        = nil
pdBlimp1        = nil
pdBlimp2        = nil
WaitInCar      = false

-- spawning events --
RegisterNetEvent('POL:Spawn')


-- commandss --
RegisterCommand("LSPD-Backup", function(source, args, raw)
    local Player = QBCore.Functions.GetPlayerData()
    if localPlayerGroup == -1 then
    localPlayerGroup = GetPedGroupIndex(PlayerPedId())
    end
    
    local jobName = Player.job.name
    print(jobName)
    if jobName == 'police' then
    TriggerEvent('POL:Spawn')
    QBCore.Functions.Notify('LSPD: BACKUP INCOMING', 'success', 4000)
    else
    QBCore.Functions.Notify('LSPD: POLICE ONLY', 'error', 4000)
    end
end)

RegisterCommand("LSPD-Test", function()
for i = 1,#Stations do
print( Stations[i] )
end
for i = 1,#StationsHeading do
print( StationsHeading[i] )
end

end, false)

RegisterCommand("LSPD-Clear", function()
        local player = PlayerPedId()
                LeaveScene()
         
end, false)

RegisterCommand("LSPD-Wait", function()
        WaitInCar = true
end, false)

RegisterCommand("LSPD-GroupGet", function()
print (GetPedGroupIndex(PlayerPedId()))
print (GetPlayerGroupID())    
end, false)

RegisterCommand("LSPD-Help", function()
        WaitInCar = false
end, false)

function GetPlayerGroupID()
if localPlayerGroup == -1 then
    localPlayerGroup = GetPedGroupIndex(PlayerPedId())
    end
    return localPlayerGroup
end

-- functions --
function EnterVehicle()
    if vehicle ~= nil then
    if not IsPedDeadOrDying(driver_ped,true) then
        TaskEnterVehicle(driver_ped, vehicle, 2000, -1, 20, 1, 0)
        while GetIsTaskActive(driver_ped, 160) do
            Wait(1)
        end
        end
        if not IsPedDeadOrDying(passenger_ped,true) then
        TaskEnterVehicle(passenger_ped, vehicle, 2000, 0, 20, 1, 0)
        while GetIsTaskActive(passenger_ped, 160) do
            Wait(1)
        end      
        end 
    end
end

function LeaveVehicle()
print("Leaving Vehicle")
    if vehicle ~= nil then
        if not IsPedDeadOrDying(driver_ped,true) then
            ClearPedTasks(driver_ped)
            TaskLeaveVehicle(driver_ped, vehicle, 0)
            --while IsPedInAnyVehicle(driver_ped, false) do
           --     Wait(1)
           -- end
        end
        if not IsPedDeadOrDying(passenger_ped,true) then
            ClearPedTasks(passenger_ped)
            TaskLeaveVehicle(passenger_ped, vehicle, 0)
           -- while IsPedInAnyVehicle(passenger_ped, false) do
           --     Wait(1)
           -- end	
        end
    end
end

function LeaveScene()
    if active then
        QBCore.Functions.Notify('LSPD: BACKUP LEAVING sequence', 'success', 4000) 
                                --SetEntityAsNoLongerNeeded(vehicle)
                                --SetPedAsNoLongerNeeded(driver_ped)
                                --SetPedAsNoLongerNeeded(passenger_ped)
                                RemovePedFromGroup(driver_ped)
                                RemovePedFromGroup(passenger_ped)
                                DeletePed(driver_ped)
                                DeletePed(passenger_ped)
                                DeleteEntity(vehicle)
                                if not vehBlip == nil then
                                RemoveBlip(vehBlip)
                                end
                                if not pdBlimp1 == nil then
                                RemoveBlip(pdBlimp1)
                                end
                                if not pdBlimp2 == nil then
                                RemoveBlip(pdBlimp2)
                                end
                            
        isCancelled = true
        active         = false
        arrived        = false
        vehicle        = nil
        driver_ped     = nil
        passenger_ped  = nil
        vehBlip        = nil
        pdBlimp1        = nil
        pdBlimp2        = nil
        WaitInCar      = false
    end
end



-- spawning events handlers --  LSPD-AI1
AddEventHandler('POL:Spawn', function(player)
    if not active then
        if player == nil then
        player = PlayerPedId()
        end

    Citizen.CreateThread(function()
    
    active = true
    isCancelled    = false
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

    --randomizer1 = math.random(10,50) -- 200 400
    --randomizer2 = math.random(10,50) -- 200 400
    
    --local offset = GetOffsetFromEntityInWorldCoords(player, 50, 50, 0)
    --local heading, spawn = GetNthClosestVehicleNodeFavourDirection(offset.x+50, offset.y+50, offset.z, pc.x, pc.y, pc.z, 16, 1, 0x40400000, 0)
    
    --clostest station
   -- pc is where i am
   local closestIndex = -1
   local distance = 9999999
    for i = 1,#Stations do
        dif = (Stations[i] - pc)
        print (#dif)
        print (distance)
        if #dif < distance then
        closestIndex = i
        distance = #dif
        
        end
    
    end
    
    
    local heading =StationsHeading[closestIndex]
    local spawnvehicle = Stations[closestIndex]
    vehicle         = CreateVehicle(police, spawnvehicle.x, spawnvehicle.y, spawnvehicle.z,heading, true, true)
    print(vehicle)
    driver_ped      = CreatePedInsideVehicle(vehicle, 6, policeman, -1, true, true)
    passenger_ped   = CreatePedInsideVehicle(vehicle, 6, policeman, 0, true, true)
    SetPedArmour(driver_ped,100)
    SetPedArmour(passenger_ped,100)
    vehBlip = AddBlipForEntity(vehicle)
    SetBlipSprite(vehBlip,41)
    --SetEntityAsMissionEntity(vehicle)
    --SetEntityAsMissionEntity(driver_ped,0,0)
    --SetEntityAsMissionEntity(passenger_ped,0,0)        
    --SetModelAsNoLongerNeeded(police)
    --SetModelAsNoLongerNeeded(policeman)  


    GiveWeaponToPed(driver_ped, GetHashKey("weapon_specialcarbine"), 250, false, true) -- Fahrer/Driver/YYY
    GiveWeaponToPed(passenger_ped, GetHashKey("WEAPON_PUMPSHOTGUN"), 250, false, true) -- Beifahrer/Passenger/XXX

    -- LoadAllPathNodes(true) -- removed in v1180
    
        while not AreAllNavmeshRegionsLoaded() do
        Wait(1)
        end   

    NetworkRequestControlOfEntity(driver_ped) -- Fahrer/Driver/YYY
    NetworkRequestControlOfEntity(passenger_ped) -- Beifahrer/Passenger/XXX

    local _, relHash = AddRelationshipGroup("POL8")
    print (relHash)
    SetPedRelationshipGroupHash(driver_ped, relHash)
    SetPedRelationshipGroupHash(passenger_ped, relHash)     
    SetRelationshipBetweenGroups(0, relHash, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), relHash)


    SetVehicleSiren(vehicle, true)
    local carFollowMode = false;
    local carDriveToLocation = false;
        if IsPedInAnyVehicle(player,false) then
        local localplayerCar = GetVehiclePedIsUsing(player)
        carFollowMode = true
        print("YOU ARE IN CAR FOLLOW MODE")

        TaskVehicleFollow(driver_ped,vehicle,localplayerCar,100.0, drivingStyle, 15.0)
        else
        print("YOU ARE ON FOOT")
        TaskVehicleDriveToCoordLongrange(driver_ped, vehicle, pc.x, pc.y, pc.z, 25.0, drivingStyle, 15.0)
        carDriveToLocation = true
        end
    Citizen.CreateThread(function()
    local updateCheck = 4
    arrived = false
    print("all good")
        while not arrived do
        Wait(1)

            if isCancelled then
            return
            end
            
            if carDriveToLocation then
                if IsPedInAnyVehicle(player,false) then -- player is now into a car and we have not arrived
                local localplayerCar = GetVehiclePedIsUsing(player)
                carFollowMode = true
                print("Switched to CAR FOLLOW MODE")
                TaskVehicleFollow(driver_ped,vehicle,localplayerCar,100.0, drivingStyle, 15.0)
                carDriveToLocation = false
                carFollowMode = true
                else
                    coordsCompare = GetEntityCoords(player)
                    if lastRecordedPlayerPosition == nil then
                    lastRecordedPlayerPosition = coordsCompare
                    end
                    distance = #(lastRecordedPlayerPosition - coordsCompare)
                    if distance > 20 then
                    lastRecordedPlayerPosition = coordsToCompare
                    TaskVehicleDriveToCoordLongrange(driver_ped, vehicle, coordsCompare.x, coordsCompare.y, coordsCompare.z, 25.0, drivingStyle, 15.0)
                    --print("NEW POS")
                    end
                                
                end
            end
            if carFollowMode then
                if not IsPedInAnyVehicle(player,false) then -- player was in a vehicle but got out
                print("Switched to Foot MODE")
                pc = GetEntityCoords(player) -- update
                TaskVehicleDriveToCoordLongrange(driver_ped, vehicle, pc.x, pc.y, pc.z, 25.0, drivingStyle, 15.0)
                carDriveToLocation = true
                carFollowMode = false
                end
            end

            if not IsPedInAnyVehicle(player,false) then -- cop is no longer in the vehicle
                if not WaitInCar then
                local coords = GetEntityCoords(vehicle)
                 coordsCompare = GetEntityCoords(player)
                                    if lastRecordedPlayerPosition == nil then
                                    lastRecordedPlayerPosition = coordsCompare
                                    end
                local distance = #(coords - lastRecordedPlayerPosition) -- faster than Vdist
                    if distance < 20.0 then
                    arrived = true
                    print("Officers have Arrived")
                    end
                end
            end


                if arrived then
                    while GetEntitySpeed(vehicle) > 0 do
                    Wait(1)
                    end
                LeaveVehicle()   
                Wait(1000)
                SetVehicleSiren(vehicle, false)
                RemoveBlip(vehBlip)

                pdBlimp1 = AddBlipForEntity(driver_ped)
                SetBlipSprite(pdBlimp1,41)
                SetBlipScale(pdBlimp1,0.5)
                pdBlimp2 = AddBlipForEntity(passenger_ped)
                SetBlipSprite(pdBlimp2,41)
                SetBlipScale(pdBlimp2,0.5)
                QBCore.Functions.Notify('LSPD: BACKUP ARRIVED', 'success', 4000)
                local playerGroupId = GetPlayerGroupID()
                print ("Before")
                print (playerGroupId)
                SetPedAsGroupMember(driver_ped, playerGroupId) 
                SetPedAsGroupMember(passenger_ped, playerGroupId)


                local coordsToTrack
                while active do
                
                Wait(5)

                    if IsPedInAnyVehicle(player,false) then
                    local localplayerCar = GetVehiclePedIsUsing(player)
                    coordsToTrack = GetEntityCoords(localplayerCar)
                    else
                    coordsToTrack = GetEntityCoords(player)
                    end

                local coordsToCompare = GetEntityCoords(driver_ped)
                local distance = #(coordsToTrack - coordsToCompare)
                    if distance > 20.0 then
                    -- too far
                    if IsPedInAnyVehicle(player,false) then
                    local playerCar = GetVehiclePedIsUsing(player)
                        if IsVehicleSeatFree(playerCar,0) then
                        TaskEnterVehicle(driver_ped,playerCar,50000,0,2,16,0)
                        elseif IsVehicleSeatFree(playerCar,1) then
                        TaskEnterVehicle(driver_ped,playerCar,50000,1,2,16,0)
                        elseif IsVehicleSeatFree(playerCar,2) then
                        TaskEnterVehicle(driver_ped,playerCar,50000,2,2,16,0)
                        else
                        print("no seats free")
                        end
                    end
                    end
                Wait(5)


                coordsToCompare = GetEntityCoords(passenger_ped)
                distance = #(coordsToTrack - coordsToCompare)
                    if distance > 20.0 then
                    -- too far
                    if IsPedInAnyVehicle(player,false) then
                    local playerCar = GetVehiclePedIsUsing(player)
                        if IsVehicleSeatFree(playerCar,0) then
                        TaskEnterVehicle(passenger_ped,playerCar,50000,0,2,16,0)
                        elseif IsVehicleSeatFree(playerCar,1) then
                        TaskEnterVehicle(passenger_ped,playerCar,50000,1,2,16,0)
                        elseif IsVehicleSeatFree(playerCar,2) then
                        TaskEnterVehicle(passenger_ped,playerCar,50000,2,2,16,0)
                        else
                         print("no seats free")
                        end
                    end
                    end
                end
            end
        end
    end)
end)
end
end)
