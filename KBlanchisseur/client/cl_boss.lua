ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyblanchimoney = nil

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

RMenu.Add('kaitoblanchi', 'boss', RageUI.CreateMenu("Organisation", "Options administratives.."))
Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('kaitoblanchi', 'boss'), true, true, true, function()

            RageUI.Separator("↓ ~r~  Montant de l'organisation ~s~↓")

            if societyblanchimoney ~= nil then
                RageUI.ButtonWithStyle("Argent de societé :", nil, {RightLabel = "~b~$" .. societyblanchimoney}, true, function()
                end)
            end
            RageUI.Separator("↓ ~y~  Panel de comptabilité  ~s~↓")

            
            RageUI.ButtonWithStyle("Déposer de l'argent",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. 'blanchi',
                    {
                        title = ('Montante')
                    }, function(data, menu)
        
                        local amount = tonumber(data.value)
        
                        if amount == nil then
                            ESX.ShowNotification('Montante Invalide')
                        else
                            menu.close()
                            TriggerServerEvent('esx_society:depositMoney', 'blanchi', amount)
                            Refreshblanchimoney()
                        end
                    end)
                end
            end) 

            RageUI.ButtonWithStyle("Retirer de l'argent",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. 'blanchi',
                    {
                        title = ('Montante')
                    }, function(data, menu)
                    local amount = tonumber(data.value)

                if amount == nil then
                    ESX.ShowNotification('Montante Invalide')
                else
                    menu.close()
                    TriggerServerEvent('esx_society:withdrawMoney', 'blanchi', amount)
                    Refreshblanchimoney()
                        end
                    end)
                end
            end)

            RageUI.Separator("↓ ~g~  Management  ~s~↓")

            RageUI.ButtonWithStyle("Gestion de l'entreprise",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)


        end, function()
        end, 1)
                        Citizen.Wait(0)
                                end
                            end)

---------------------------------------------

local position = {
    {x = -1744.40, y = -125.91, z = 48.60}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do
           if ESX.PlayerData.job and ESX.PlayerData.job.name == 'blanchi' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'blanchi' and ESX.PlayerData.job2.grade_name == 'boss' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            DrawMarker(20, -1744.40, -125.91, 48.30, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)

        
            if dist <= 1.0 then
                RageUI.Text({

                    message = "Appuyez sur [~r~E~w~] pour accéder au panel administratif",

                    time_display = 1

                })
                if IsControlJustPressed(1,51) then
                    Refreshblanchimoney()
                    RageUI.Visible(RMenu:Get('kaitoblanchi', 'boss'), not RageUI.Visible(RMenu:Get('kaitoblanchi', 'boss')))
                end
            end
        end
    end
    end
end)

function Refreshblanchimoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            Updatesocietyblanchimoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function Updatesocietyblanchimoney(money)
    societyblanchimoney = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'blanchi', function(data, menu)
        menu.close()
    end, {wash = false})
end