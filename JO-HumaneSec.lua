local markerPos1 = vector3(3425.88, 3757.25, 30.49)
local HasAlreadyGotMessage1 = false

Citizen.CreateThread(function()
   while true do
	local ped = GetPlayerPed(-1)
   	
	Citizen.Wait(0)
	local playerCoords1 = GetEntityCoords(ped)
	local distance1 = #(playerCoords1 - markerPos1)
	local isInMarker1 = false	

		if distance1 < 80.0 then
		--DrawMarker(42, markerPos.x, markerPos.y, markerPos.z , 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 50, false, false, 2, nil, nil, false)
	    	if distance1 < 80.0 then
			   isInMarker1 = true
			else
			   HasAlreadyGotMessage1 = false
			end
		else
			Citizen.Wait(2000)
		end
	
		-- Security Ped
		if isInMarker1 and not HasAlreadyGotMessage1 then
		
		RequestModel(0x2EFEAFD5) 
		humanesecurityA = CreatePed(30, 0x2EFEAFD5, 3513.47, 3759.2, 30.12, 348.42, true, false)
		SetPedArmour(humanesecurityA, 0)
		SetPedAsEnemy(humanesecurityA, true)
		SetPedRelationshipGroupHash(humanesecurityA, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityA, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityA, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityA, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityA, true)
		Citizen.Wait(500)

		
		humanesecurityB =  CreatePed(30, 0x2EFEAFD5, 3515.9, 3757.14, 30.70, 348.42, true, false)
		SetPedArmour(humanesecurityB, 0)
		SetPedAsEnemy(humanesecurityB, true)
		SetPedRelationshipGroupHash(humanesecurityB, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityB, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityB, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityB, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityB, true)
		Citizen.Wait(500)
		
		
		humanesecurityC =  CreatePed(30, 0x2EFEAFD5, 3519.09, 3756.09, 30.70, 348.42, true, false)
		SetPedArmour(humanesecurityC, 0)
		SetPedAsEnemy(humanesecurityC, true)
		SetPedRelationshipGroupHash(humanesecurityC, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityC, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityC, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityC, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityC, true)
		Citizen.Wait(500)

		
		humanesecurityD =  CreatePed(30, 0x2EFEAFD5, 3431.32, 3671.54, 41.34, 348.37, true, false)
		SetPedArmour(humanesecurityD, 0)
		SetPedAsEnemy(humanesecurityD, true)
		SetPedRelationshipGroupHash(humanesecurityD, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityD, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityD, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityD, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityD, true)
		Citizen.Wait(500)

		RequestModel(0x2EFEAFD5) 
		humanesecurityE = CreatePed(30, 0x2EFEAFD5, 3538.96, 3754.07, 30.12, 348.42, true, false)
		SetPedArmour(humanesecurityE, 0)
		SetPedAsEnemy(humanesecurityE, true)
		SetPedRelationshipGroupHash(humanesecurityE, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityE, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityE, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityE, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityE, true)
		Citizen.Wait(500)

		RequestModel(0x2EFEAFD5) 
		humanesecurityF = CreatePed(30, 0x2EFEAFD5, 3473.03, 3751.02, 35.64, 348.42, true, false)
		SetPedArmour(humanesecurityF, 0)
		SetPedAsEnemy(humanesecurityF, true)
		SetPedRelationshipGroupHash(humanesecurityF, 0xF50B51B7)
		GiveWeaponToPed(humanesecurityF, GetHashKey('WEAPON_SMG'), 250, false, true)
		TaskCombatPed(humanesecurityF, GetPlayerPed(-1))
		SetPedAccuracy(humanesecurityF, 60)
		SetPedDropsWeaponsWhenDead(humanesecurityF, true)
		Citizen.Wait(500)
		HasAlreadyGotMessage1 = true
		
		end
	
   end	
end)