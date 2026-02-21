QBCore = exports['qb-core']:GetCoreObject()

local plateModel = "prop_fib_badge"
local animDict = "missfbi_s4mop"
local animName = "swipe_card"
local plate_net = nil

local open = false

-- Helper: detach, delete, and clear the badge prop referenced by plate_net.
local function cleanupBadgeProp()
	if plate_net then
		local ent = NetToObj(plate_net)
		if DoesEntityExist(ent) then
			DetachEntity(ent, 1, 1)
			DeleteEntity(ent)
		end
		plate_net = nil
	end
end

RegisterNetEvent('badge:open')
AddEventHandler('badge:open', function(data, type)
	open = true
	SendNUIMessage({
		action = "open",
		name = data.name,
		rank = data.rank,
		csi = data.csi
	})
	cleanupBadgeProp()
	Citizen.Wait(4000)
	SendNUIMessage({
		action = "close"
	})
	open = false
end)

Citizen.CreateThread(function()
	while true do
		if open then
			Wait(0)
			if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
				SendNUIMessage({
					action = "close"
				})
				open = false
			end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('showbadge')
AddEventHandler('showbadge', function()
	local player, distance = QBCore.Functions.GetClosestPlayer()
	local targetServerId = (distance ~= -1 and distance <= 2.0)
		and GetPlayerServerId(player)
		or GetPlayerServerId(PlayerId())
	TriggerServerEvent('badge:open', targetServerId)
	cleanupBadgeProp()
end)

function startAnim()
    RequestModel(GetHashKey(plateModel))
    while not HasModelLoaded(GetHashKey(plateModel)) do
        Citizen.Wait(100)
    end
	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
    local platespawned = CreateObject(GetHashKey(plateModel), plyCoords.x, plyCoords.y, plyCoords.z, 0, 0, 0)
    Citizen.Wait(1000)
    local netid = ObjToNet(platespawned)
    SetNetworkIdExistsOnAllMachines(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
    Citizen.Wait(800)
    AttachEntityToEntity(platespawned, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    plate_net = netid
    Citizen.Wait(3000)
    ClearPedSecondaryTask(playerPed)
	cleanupBadgeProp()
end

RegisterNetEvent('badge:openPD')
AddEventHandler('badge:openPD', function()
	TriggerEvent('showbadge')
	QBCore.Functions.Progressbar("search_register", "Showing Badge", 3500, false, true, {disableMovement = false,
	disableCarMovement = true,
	disableMouse = false,
	disableCombat = true,
	disableInventory = true,
}, {}, {}, {}, function()end, function()       
end)
	startAnim()
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

-- Default sprite position/size used when the resolution does not have a specific entry.
local defaultBadgePos = { posx = 0.12, posy = 0.35, width = 0.07, height = 0.14 }

-- Per-resolution overrides for the badge headshot sprite.
local resolutionBadgePos = {
	[2560] = { [1440] = { posx = 0.11,   posy = 0.27,   width = 0.06,  height = 0.1    } },
	[1920] = { [1080] = { posx = 0.12,   posy = 0.35,   width = 0.07,  height = 0.14   } },
	[1680] = { [1050] = { posx = 0.138,  posy = 0.367,  width = 0.069, height = 0.1435 } },
	[1600] = { [900]  = { posx = 0.136,  posy = 0.4222, width = 0.073, height = 0.153  } },
	[1440] = { [900]  = { posx = 0.152,  posy = 0.422,  width = 0.082, height = 0.169  } },
	[1400] = { [1050] = { posx = 0.694,  posy = 0.267,  width = 0.083, height = 0.145  } },
	[1366] = { [768]  = { posx = 0.148,  posy = 0.503,  width = 0.086, height = 0.176  } },
	[1360] = { [768]  = { posx = 0.145,  posy = 0.323,  width = 0.087, height = 0.196  } },
	[1280] = {
		[720]  = { posx = 0.665, posy = 0.3905, width = 0.09,  height = 0.2105 },
		[768]  = { posx = 0.665, posy = 0.366,  width = 0.091, height = 0.196  },
		[800]  = { posx = 0.665, posy = 0.3515, width = 0.091, height = 0.1895 },
		[960]  = { posx = 0.665, posy = 0.2925, width = 0.091, height = 0.1585 },
		[1024] = { posx = 0.1785,posy = 0.370,  width = 0.091, height = 0.1475 },
		[600]  = { posx = 0.665, posy = 0.468,  width = 0.0905,height = 0.251  },
	},
	[1152] = { [864]  = { posx = 0.6275, posy = 0.325,  width = 0.1005,height = 0.175  } },
	[1024] = { [768]  = { posx = 0.5810, posy = 0.366,  width = 0.115, height = 0.1965 } },
	[800]  = { [600]  = { posx = 0.4635, posy = 0.4685, width = 0.1455,height = 0.251  } },
}

RegisterNetEvent('badge:shot')
AddEventHandler('badge:shot', function(playerID)
	local x, y = GetActiveScreenResolution()
	local pos = (resolutionBadgePos[x] and resolutionBadgePos[x][y]) or defaultBadgePos
	local posx, posy, width, height = pos.posx, pos.posy, pos.width, pos.height

	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerID))
	local handle = RegisterPedheadshot(playerPed)

	while not IsPedheadshotReady(handle) do
		Wait(100)
	end

	local headshot = GetPedheadshotTxdString(handle)
	while open do
		Wait(5)
		-- The last parameter (alpha) must be in the 0-255 range; DrawSprite expects an integer.
		DrawSprite(headshot, headshot, posx, posy, width, height, 0.0, 255, 255, 255, 255)
	end
	-- Always unregister the headshot when the badge closes.
	UnregisterPedheadshot(handle)
end)
