ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


---------------- FONCTIONS ------------------

RMenu.Add('kaitoleplusbeau', 'kaitoleplusfrais', RageUI.CreateMenu("Organisation", "Processus en cours..."))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('kaitoleplusbeau', 'kaitoleplusfrais'), true, true, true, function()

			RageUI.Separator("↓ ~y~   Blanchiment d'argent  ~s~↓")

			RageUI.ButtonWithStyle("Insérer la kichta..", nil, {RightLabel = ">>>"}, true, function(_, _, s)
				if s then
					local argent = KeyboardInput("Combien d'argent as-tu ?", '' , '', 8)
					TriggerServerEvent('KaitoOnTheFlux:blanchiment', argent)	
					ESX.ShowColoredNotification('✅ Action effectuée.', 18) 
                end
            end)

        end, function()
        end, 1)
                        Citizen.Wait(0)
                                end
                            end)

---------------------------------------------

local position = {
	{x = -1728.40, y = -112.97, z = 48.60}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'blanchi' then 

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
			DrawMarker(20, -1728.40,  -112.97, 47.60+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)

        
            if dist <= 1.0 then
				RageUI.Text({

					message = "Appuyez sur [~r~E~w~] pour mettre les sous à laver",
		
					time_display = 1
		
				})
                if IsControlJustPressed(1,51) then
                    RageUI.Visible(RMenu:Get('kaitoleplusbeau', 'kaitoleplusfrais'), not RageUI.Visible(RMenu:Get('kaitoleplusbeau', 'kaitoleplusfrais')))
                end
            end
        end
    end
    end
end)