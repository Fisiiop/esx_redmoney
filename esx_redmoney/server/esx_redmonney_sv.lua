ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingPaper     = {}
local PlayersTransformingPaper   = {}
local PlayersSellingRedmonney        = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(5000, CountCops)

end

CountCops()

--paper
local function HarvestPaper(source)

	if CopsConnected < Config.RequiredCopsRedmonney then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsRedmonney)
		return
	end

	SetTimeout(2500, function()

		if PlayersHarvestingPaper[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local paper = xPlayer.getInventoryItem('paper')

			if paper.limit ~= -1 and paper.count >= paper.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_paper'))
			else
				xPlayer.addInventoryItem('paper', 1)
				HarvestPaper(source)
			end

		end
	end)
end

RegisterServerEvent('esx_redmonney:startHarvestPaper')
AddEventHandler('esx_redmonney:startHarvestPaper', function()

	local _source = source

	PlayersHarvestingPaper[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestPaper(_source)

end)

RegisterServerEvent('esx_redmonney:stopHarvestPaper')
AddEventHandler('esx_redmonney:stopHarvestPaper', function()

	local _source = source

	PlayersHarvestingPaper[_source] = false

end)

local function TransformPaper(source)

	if CopsConnected < Config.RequiredCopsRedmonney then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsRedmonney)
		return
	end

	SetTimeout(5000, function()

		if PlayersTransformingPaper[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local paperQuantity = xPlayer.getInventoryItem('paper').count
			local redmonneyQuantity = xPlayer.getInventoryItem('redmonney').count

			if redmonneyQuantity > 50 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif paperQuantity < 1 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_paper'))
			else
				xPlayer.removeInventoryItem('paper', 1)
				xPlayer.addInventoryItem('redmonney', 1)
			
				TransformPaper(source)
			end

		end
	end)
end

RegisterServerEvent('esx_redmonney:startTransformPaper')
AddEventHandler('esx_redmonney:startTransformPaper', function()

	local _source = source

	PlayersTransformingPaper[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformPaper(_source)

end)

RegisterServerEvent('esx_redmonney:stopTransformPaper')
AddEventHandler('esx_redmonney:stopTransformPaper', function()

	local _source = source

	PlayersTransformingPaper[_source] = false

end)

local function SellRedmonney(source)

	if CopsConnected < Config.RequiredCopsRedmonney then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsRedmonney)
		return
	end

	SetTimeout(1000, function()

		if PlayersSellingRedmonney[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local poochQuantity = xPlayer.getInventoryItem('redmonney').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('redmonney', 1)
				if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 300)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 320)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 340)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 350)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 380)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                elseif CopsConnected >= 5 then
                    xPlayer.addAccountMoney('black_money', 400)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_redmonney'))
                end
				
				SellRedmonney(source)
			end

		end
	end)
end

RegisterServerEvent('esx_redmonney:startSellRedmonney')
AddEventHandler('esx_redmonney:startSellRedmonney', function()

	local _source = source

	PlayersSellingRedmonney[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellRedmonney(_source)

end)

RegisterServerEvent('esx_redmonney:stopSellRedmonney')
AddEventHandler('esx_redmonney:stopSellRedmonney', function()

	local _source = source

	PlayersSellingRedmonney[_source] = false

end)


-- RETURN INVENTORY TO CLIENT
RegisterServerEvent('esx_redmonney:GetUserInventory')
AddEventHandler('esx_redmonney:GetUserInventory', function(currentZone)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_redmonney:ReturnInventory', 
    	_source,
		xPlayer.getInventoryItem('paper').count, 
		xPlayer.getInventoryItem('redmonney').count,
		xPlayer.job.name, 
		currentZone
    )
end)
