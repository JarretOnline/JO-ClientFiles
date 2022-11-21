local veh = nil
local tesla_blip = nil
local tesla_pilot = false
local tesla_pilot_ped = nil
local tesla_dance = false

local pilot = false
local crash = false
local dance = false
local crash_ped_fl = nil
local crash_ped_fr = nil
local crash_ped_rl = nil
local crash_ped_rr = nil



TriggerEvent('chat:addSuggestion', '/auto', 'Vehicle Features', {{name="pilot | dance | mark", help="Auto Pilot, Dance, Mark Vehicle"}})
RegisterCommand("auto", function(source, args)
	if(args[1] == "mark") then
		if(IsPedInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
			veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--minimap("This vehicle is now marked as your Vehicle.\nIt can be controlled when you are not sitting in it.")
			exports['okokNotify']:Alert("AUTO PILOT", "VEHICLE MARKED ON GPS", 2000, 'success')
			if(DoesBlipExist(tesla_blip)) then
				RemoveBlip(tesla_blip)
			end
			tesla_blip = AddBlipForEntity(veh)
			SetBlipSprite(tesla_blip, 595)
			SetBlipColour(tesla_blip, 26)
			BeginTextCommandSetBlipName("STRING")
      		AddTextComponentString("Vehicle")
			EndTextCommandSetBlipName(tesla_blip)
		else
			veh = nil
			--minimap("Your Vehicle has been unmarked.")
			exports['okokNotify']:Alert("AUTO PILOT", "VEHICLE MARK REMOVED", 2000, 'error')
			if(DoesBlipExist(tesla_blip)) then
				RemoveBlip(tesla_blip)
			end
			tesla_blip = nil
		end
	else
		if(IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
			if(args[1] == "pilot") then
				waypoint = Citizen.InvokeNative(0xFA7C7F0AADF25D09, GetFirstBlipInfoId(8), Citizen.ResultAsVector())
				print(waypoint)
				if(IsWaypointActive()) then
					if(pilot) then
						pilot = false
						--minimap("Auto-Pilot canceled.")
						exports['okokNotify']:Alert("AUTO PILOT", "STOPPED", 2000, 'error')
						ClearPedTasks(GetPlayerPed(-1))
					else
						--[[
						if(crash) then
							crash = false
							--minimap("Crash-Avoidance deactivated.")
							exports['okokNotify']:Alert("AUTOPILOT", "CRASH CHECK DISABLED", 2000, 'error')
							--DeletePed(crash_ped_fl)
							DeleteEntity(crash_ped_fl)
							--DeletePed(crash_ped_fr)
							DeleteEntity(crash_ped_fr)
							--DeletePed(crash_ped_front)
							DeleteEntity(crash_ped_front)
							--DeletePed(crash_ped_rear)
							DeleteEntity(crash_ped_rear)
						end
						]]--

						pilot = true
						--minimap("AutoPilot activated.")
						exports['okokNotify']:Alert("AUTO PILOT", "ACTIVATED", 2000, 'success')
						TaskVehicleDriveToCoord(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), waypoint["x"], waypoint["y"], waypoint["z"], 22.0, 10.0, GetHashKey(GetVehiclePedIsIn(GetPlayerPed(-1), 0)), 786603, 1.0, 1)
						Citizen.CreateThread(function()
							while pilot do
								Wait(100)
								if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1))["x"], GetEntityCoords(GetPlayerPed(-1))["y"], GetEntityCoords(GetPlayerPed(-1))["z"], waypoint["x"], waypoint["y"], waypoint["z"], 0) < 10.0) then
									while GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0)) - 1.0 > 10.0 do
										SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0), GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0)) - 1.0)
										Wait(100)
									end
									pilot = false
									ClearPedTasks(GetPlayerPed(-1))
									--minimap("Auto-Pilot deactivated.")
									exports['okokNotify']:Alert("AUTO PILOT", "STOPPED", 2000, 'error')
								end
							end
						end)
					end
				else
					--minimap("No waypoint set.")
					exports['okokNotify']:Alert("AUTO PILOT", "BEEP! BOOP! MARK YOUR GPS!", 2000, 'error')
				end
			elseif(args[1] == "dance") then
				if(dance) then
					dance = false
					SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
					--minimap("Dance-Mode stopped.")
					exports['okokNotify']:Alert("AUTO PILOT", "SAD CAR! NO DANCE!", 2000, 'error')
				else
					dance = true
					--minimap("Dance-Mode started.")
					exports['okokNotify']:Alert("AUTO PILOT", "BEEP! BOOP! CAR DANCE!", 2000, 'success')
					Citizen.CreateThread(function()
						while dance do
							Wait(100)
							SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), math.random(0, 6), false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), math.random(0, 6), false)
						end
					end)
				end
			else
				--minimap("Unknown action.")
				exports['okokNotify']:Alert("AUTO PILOT", "UNKNOWN ACTION", 2000, 'error')
			end
		elseif(veh) then
			if(args[1] == "pilot") then
				if(tesla_pilot) then
					if(tesla_pilot_ped) then
						--DeletePed(tesla_pilot_ped)
						RemovePedElegantly(tesla_pilot_ped)
					end
					tesla_pilot = false
					tesla_pilot_ped = nil
					SetVehicleEngineOn(veh, false, false, false)
					--minimap("Auto-Pilot canceled.")
					exports['okokNotify']:Alert("AUTO PILOT", "STOPPED", 2000, 'error')
				else
					RequestModel(225514697)
					while not HasModelLoaded(225514697) do
						Wait(5)
					end
					--minimap("Auto-Pilot activated.")
					exports['okokNotify']:Alert("AUTO PILOT", "STARTED", 2000, 'error')
					tesla_pilot = true
					tesla_pilot_ped = CreatePed(0, 225514697, GetEntityCoords(veh)["x"], GetEntityCoords(veh)["y"], GetEntityCoords(veh)["z"], 0.0, false, true)
					SetPedIntoVehicle(tesla_pilot_ped, veh, -1)
					SetEntityInvincible(tesla_pilot_ped, true)
					SetEntityVisible(tesla_pilot_ped, false, 0)
					player_coords = GetEntityCoords(GetPlayerPed(-1))
					TaskVehicleDriveToCoord(tesla_pilot_ped, veh, player_coords.x, player_coords.y, player_coords.z, 100.0, 1.0, GetHashKey(veh), 786603, 1.0, 1)
					Citizen.CreateThread(function()
						while tesla_pilot do
							Wait(100)
							if(GetDistanceBetweenCoords(GetEntityCoords(veh)["x"], GetEntityCoords(veh)["y"], GetEntityCoords(veh)["z"], player_coords.x, player_coords.y, player_coords.z, 0) < 10.0) then
								while GetEntitySpeed(veh) - 1.0 > 0.0 do
									SetVehicleForwardSpeed(veh, GetEntitySpeed(veh) - 1.0)
									Wait(100)
								end
								tesla_pilot = false
								--DeletePed(tesla_pilot_ped)
								RemovePedElegantly(tesla_pilot_ped)
								tesla_pilot_ped = nil
								SetVehicleEngineOn(veh, false, false, false)
								--minimap("Auto-Pilot deactivated.")
								exports['okokNotify']:Alert("AUTO PILOT", "STOPPED", 2000, 'error')
							end
						end
					end)
				end
			elseif(args[1] == "dance") then
				if(tesla_dance) then
					tesla_dance = false
					SetVehicleDoorsShut(veh, false)
					--minimap("Dance-Mode stopped.")
					exports['okokNotify']:Alert("AUTO PILOT", "SAD CAR! NO DANCE!", 2000, 'error')
				else
					tesla_dance = true
					--minimap("Dance-Mode started.")
					exports['okokNotify']:Alert("AUTO PILOT", "BLEEP! BLURP! DANCE!", 2000, 'success')
					Citizen.CreateThread(function()
						while tesla_dance do
							Wait(100)
							SetVehicleDoorOpen(veh, math.random(0, 6), false, false)
							SetVehicleDoorShut(veh, math.random(0, 6), false)
						end
					end)
				end
			end
		else
			--minimap("Unknown vehicle.")
			exports['okokNotify']:Alert("AUTO PILOT", "VEHICLE NOT DETECTED", 2000, 'error')
		end
	end
end, false)

function minimap(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end

function translatespeed(float)
local speed = float - 20
return speed
end

autopilotenabled = false
Citizen.CreateThread(function()
    while true do
			local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
			local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))
			local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))
			local distbetween = Vdist(x,y,z,px,py,pz)
			--x if IsControlPressed(1,36) then
			--x	if IsControlJustPressed(1,21) then
			--x		if GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -1894894188 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -429774847 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -1622444098 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == 884483972 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == 569305213 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -1285460620 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -1529242755 or GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())) == -429774847 then
			--x				autopilotenabled = not autopilotenabled
							if autopilotenabled then

								if(not IsWaypointActive())then 
									exports['okokNotify']:Alert("AUTO PILOT", "BEEP. BOOP. MARK YOUR GPS!", 2000, 'error')
								else
									defaultspeed = 10.0  --1 = 3 MPH 5 = 11 MPH
									TaskVehicleDriveToCoordLongrange(PlayerPedId(),GetVehiclePedIsUsing(PlayerPedId()), x,y,z, defaultspeed, 262579, 10.0) --262579
								end
							else

							end
			--x		else

			--x		end
			--x end			
			--x end
			
			--[[
			if autopilotenabled then
				
				if IsControlJustPressed(0, 71) and GetLastInputMethod( 0 ) then
										defaultspeed = defaultspeed + 1.0
										TaskVehicleDriveToCoordLongrange(PlayerPedId(),GetVehiclePedIsUsing(PlayerPedId()), x,y,z, defaultspeed, 262579, 10.0)
				end
				if IsControlJustPressed(0,72) and GetLastInputMethod( 0 ) then
										defaultspeed = defaultspeed - 1.0
										TaskVehicleDriveToCoordLongrange(PlayerPedId(),GetVehiclePedIsUsing(PlayerPedId()), x,y,z, defaultspeed, 262579, 10.0)
				end				
				if IsControlJustPressed(0,76) and GetLastInputMethod( 0 ) then
										defaultspeed = 0.0
										TaskVehicleDriveToCoordLongrange(PlayerPedId(),GetVehiclePedIsUsing(PlayerPedId()), x,y,z, defaultspeed, 262579, 10.0)
										TaskPause(PlayerPedId(), 10)
										autopilotenabled = false
										
				end
			end
			]]--
			
        Citizen.Wait(0)
    end
end)
