local markerPos = vector3(-634.65, -239.89, 38.06)
local HasAlreadyGotMessage = false

Citizen.CreateThread(function()
   while true do
	local ped = GetPlayerPed(-1)
   	
	Citizen.Wait(0)
	local playerCoords = GetEntityCoords(ped)
	local distance = #(playerCoords - markerPos)
	local isInMarker = false	

		if distance < 80.0 then
	    	if distance < 80.0 then
			   isInMarker = true
			else
			   HasAlreadyGotMessage = false
			end
		else
			Citizen.Wait(2000)
		end
	
		-- Security Peds
		if isInMarker and not HasAlreadyGotMessage then
		
		RequestModel(0x2EFEAFD5) 
		humanesecurity1 = CreatePed(30, 0x2EFEAFD5, -626.01, -223.95, 38.06, 187.96, true, false)
		SetPedArmour(humanesecurity1, 0)
		SetPedAsEnemy(humanesecurity1, true)
		SetPedRelationshipGroupHash(humanesecurity1, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity1, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity1, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity1, 60)
		SetPedDropsWeaponsWhenDead(humanesecurity1, true)
		Citizen.Wait(500)

		
		humanesecurity2 =  CreatePed(30, 0x2EFEAFD5, -630.1, -240.68, 38.16, 121.08, true, false)
		SetPedArmour(humanesecurity2, 0)
		SetPedAsEnemy(humanesecurity2, true)
		SetPedRelationshipGroupHash(humanesecurity2, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity2, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity2, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity2, 60)
		SetPedDropsWeaponsWhenDead(humanesecurity2, true)
		Citizen.Wait(500)
		

		humanesecurity3 =  CreatePed(30, 0x2EFEAFD5, -633.88, -235.02, 37.98, 124.01, true, false)
		SetPedArmour(humanesecurity3, 0)
		SetPedAsEnemy(humanesecurity3, true)
		SetPedRelationshipGroupHash(humanesecurity3, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity3, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity3, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity3, 60)
		SetPedDropsWeaponsWhenDead(govfacility4, true)
		Citizen.Wait(500)

		
		humanesecurity4 =  CreatePed(30, 0x2EFEAFD5, -616.82, -235.45, 38.06, 94.91, true, false)
		SetPedArmour(humanesecurity4, 0)
		SetPedAsEnemy(humanesecurity4, true)
		SetPedRelationshipGroupHash(humanesecurity4, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity4, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity4, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity4, 60)
		SetPedDropsWeaponsWhenDead(govfacility4, true)
		Citizen.Wait(500)

		RequestModel(0x2EFEAFD5) 
		humanesecurity1 = CreatePed(30, 0x2EFEAFD5, -619.16, -225.82, 38.06, 129.66, true, false)
		SetPedArmour(humanesecurity1, 0)
		SetPedAsEnemy(humanesecurity1, true)
		SetPedRelationshipGroupHash(humanesecurity1, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity1, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity1, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity1, 60)
		SetPedDropsWeaponsWhenDead(humanesecurity1, true)
		Citizen.Wait(500)

		RequestModel(0x2EFEAFD5)
		humanesecurity1 = CreatePed(30, 0x2EFEAFD5, -616.57, -229.15, 38.06, 126.11, true, false)
		SetPedArmour(humanesecurity1, 0)
		SetPedAsEnemy(humanesecurity1, true)
		SetPedRelationshipGroupHash(humanesecurity1, 0xF50B51B7)
		GiveWeaponToPed(humanesecurity1, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurity1, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurity1, 60)
		SetPedDropsWeaponsWhenDead(humanesecurity1, true)
		Citizen.Wait(500)
		HasAlreadyGotMessage = true
		end
	
   end	
end)