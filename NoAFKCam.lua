---By Anunaki Artax (FR) (-_-)♣

Citizen.CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		Wait(0) --[EN]Now is 0 , The idle camera activates after 30 second so we don't need to call this per frame (Nice for Cinema & TV)
	end         --[FR]la c'est 0 , La caméra inactive s'active après 30 secondes, nous n'avons donc pas besoin de l'appeler par image (Bien pour le cinema & TV)
end)

Citizen.CreateThread(function() 
  while true do
    N_0xf4f2c0d4ee209e20() 
    Wait(0)     --[EN]Now is 0 , The idle camera activates after 30 second so we don't need to call this per frame (Nice for Cinema & TV)
  end           --[FR]la c'est 0 , La caméra inactive s'active après 30 secondes, nous n'avons donc pas besoin de l'appeler par image (Bien pour le cinema & TV)
end)