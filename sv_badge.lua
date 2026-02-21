local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('badge:open')
AddEventHandler('badge:open', function(targetID, type)
	-- Use server-authoritative source; never trust a client-supplied player ID.
	local callerID = source
	local Player = QBCore.Functions.GetPlayer(callerID)

	if not Player then return end

	local charinfo = Player.PlayerData.charinfo
	local job      = Player.PlayerData.job
	local meta     = Player.PlayerData.metadata

	local fname = charinfo and charinfo.firstname or "Unknown"
	local lname = charinfo and charinfo.lastname or ""
	local data = {
		name = fname .. " " .. lname,
		rank = job and job.grade and job.grade.name or "Unknown",
		csi  = meta and meta.callsign or ""
	}

	-- Validate targetID is a real connected player; fall back to caller.
	local resolvedTarget = targetID
	if not GetPlayerName(resolvedTarget) then
		resolvedTarget = callerID
	end

	TriggerClientEvent('badge:open', resolvedTarget, data)
	TriggerClientEvent('badge:shot', resolvedTarget, callerID)
end)

QBCore.Functions.CreateUseableItem('specialbadge', function(source, item)
    TriggerClientEvent('badge:openPD', source, true)
end)