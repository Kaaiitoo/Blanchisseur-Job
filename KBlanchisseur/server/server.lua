ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'blanchi', 'alerte blanchi', true, true)

TriggerEvent('esx_society:registerSociety', 'blanchi', 'blanchi', 'society_blanchi', 'society_blanchi', 'society_blanchi', {type = 'public'})

RegisterServerEvent('esx_mafiajob:prendreitems')
AddEventHandler('esx_mafiajob:prendreitems', function(itemName, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        if count > 0 and inventoryItem.count >= count then

            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', _source, 'objet retiré', count, inventoryItem.label)
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
        end
    end)
end)


RegisterNetEvent('esx_mafiajob:stockitem')
AddEventHandler('esx_mafiajob:stockitem', function(itemName, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        if sourceItem.count >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            TriggerClientEvent('esx:showNotification', _source, "objet déposé "..count..""..inventoryItem.label.."")
        else
            TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
        end
    end)
end)


ESX.RegisterServerCallback('esx_mafiajob:inventairejoueur', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.inventory

    cb({items = items})
end)

ESX.RegisterServerCallback('esx_mafiajob:prendreitem', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
        cb(inventory.items)
    end)
end)

ESX.RegisterServerCallback('esx_mafiajob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_blanchi', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_mafiajob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_blanchi', function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_mafiajob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_blanchi', function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

-------------- INTERACTION ------------

RegisterServerEvent('e_bcso:requestarrest')
AddEventHandler('e_bcso:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('e_bcso:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('e_bcso:doarrested', _source)
end)

RegisterServerEvent('e_bcso:requestrelease')
AddEventHandler('e_bcso:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('e_bcso:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('e_bcso:douncuffing', _source)
end)

RegisterServerEvent('e_bcso:handcuff')
AddEventHandler('e_bcso:handcuff', function(target)
  TriggerClientEvent('e_bcso:handcuff', target)
end)

RegisterServerEvent('e_bcso:drag')
AddEventHandler('e_bcso:drag', function(target)
  local _source = source
  TriggerClientEvent('e_bcso:drag', target, _source)
end)

RegisterServerEvent('e_bcso:putInVehicle')
AddEventHandler('e_bcso:putInVehicle', function(target)
  TriggerClientEvent('e_bcso:putInVehicle', target)
end)

RegisterServerEvent('e_bcso:OutVehicle')
AddEventHandler('e_bcso:OutVehicle', function(target)
    TriggerClientEvent('e_bcso:OutVehicle', target)
end)

ESX.RegisterServerCallback('e_bcso:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", target, "~r~Quelqu'un vous fouille ...")

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }

        cb(data)
    end
end)

RegisterNetEvent('jejey:confiscatePlayerItem')
AddEventHandler('jejey:confiscatePlayerItem', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		
			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem   (itemName, amount)
            TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount..' '..sourceItem.label.."~s~.")
            TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a pris ~b~"..amount..' '..sourceItem.label.."~s~.")
        else
			TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide")
		end
        
    if itemType == 'item_account' then
        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney   (itemName, amount)
        
        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount.." d' "..itemName.."~s~.")
        TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous aconfisqué ~b~"..amount.." d' "..itemName.."~s~.")
        
    elseif itemType == 'item_weapon' then
        if amount == nil then amount = 0 end
        targetXPlayer.removeWeapon(itemName, amount)
        sourceXPlayer.addWeapon   (itemName, amount)

        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")
        TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")
    end
end)

RegisterServerEvent('KaitoOnTheFlux:blanchiment')
AddEventHandler('KaitoOnTheFlux:blanchiment', function(argent)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local taxe = 1.0    -- Le blanchisseur prend 35% (1-0.65 = 0.35)

	argent = ESX.Math.Round(tonumber(argent))
	pourcentage = argent * taxe
	Total = ESX.Math.Round(tonumber(pourcentage))

	if argent > 0 and xPlayer.getAccount('black_money').money >= argent then
		xPlayer.removeAccountMoney('black_money', argent)
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Blanchiment', 'Attends ~r~1 heure pour l\'opération', 'CHAR_MP_FM_CONTACT', 8)
		Citizen.Wait(3600000)
		
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Blanchiment', 'Tu as reçu : ' .. ESX.Math.GroupDigits(Total) .. ' ~g~$', 'CHAR_MP_FM_CONTACT', 8)
		xPlayer.addMoney(Total)
	else
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Information', 'Blanchiment', '~r~Montant invalide', 'CHAR_MP_FM_CONTACT', 8)
	end	
end)