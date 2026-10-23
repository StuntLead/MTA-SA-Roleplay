--[[
    admin-api - MTA Web Admin API Bridge
    Author: StuntLead
    Purpose: Provides secure HTTP API for external web admin panel
--]]

-- Get list of currently connected players
function getOnlinePlayers()
    local players = {}
    for _, player in ipairs(getElementsByType("player")) do
        local accountID = tonumber(getElementData(player, "account:id")) or 0
        local accountName = getElementData(player, "account:username") or "Guest"
        local charName = getPlayerName(player) or "Unknown"
        local charID = tonumber(getElementData(player, "dbid")) or 0
        local ping = getPlayerPing(player) or 0
        local ip = getPlayerIP(player) or "127.0.0.1"
        local health = math.floor(getElementHealth(player) or 0)
        local armor = math.floor(getPedArmor(player) or 0)
        local adminLevel = tonumber(getElementData(player, "admin_level")) or 0
        local hoursPlayed = tonumber(getElementData(player, "hoursplayed")) or 0
        local x, y, z = getElementPosition(player)
        local zone = getZoneName(x, y, z) or "San Andreas"
        local money = 0
        if exports.global and exports.global.getMoney then
            money = exports.global:getMoney(player) or 0
        else
            money = getPlayerMoney(player) or 0
        end

        local bank = tonumber(getElementData(player, "bankmoney")) or 0

        table.insert(players, {
            id = getElementData(player, "playerid") or _,
            element_id = _,
            account_id = accountID,
            account_name = tostring(accountName),
            character_id = charID,
            character_name = tostring(charName):gsub("_", " "),
            raw_name = tostring(charName),
            ping = ping,
            ip = ip,
            health = health,
            armor = armor,
            admin_level = adminLevel,
            hours_played = hoursPlayed,
            location = zone,
            coordinates = { x = math.floor(x * 10) / 10, y = math.floor(y * 10) / 10, z = math.floor(z * 10) / 10 },
            cash = money,
            bank = bank
        })
    end
    return players
end

-- Get list of all resources and their states
function getResourcesList()
    local resources = {}
    local allResources = getResources()
    for _, res in ipairs(allResources) do
        local name = getResourceName(res)
        local state = getResourceState(res)
        local resType = getResourceInfo(res, "type") or "script"
        local author = getResourceInfo(res, "author") or "N/A"
        local version = getResourceInfo(res, "version") or "1.0.0"
        local desc = getResourceInfo(res, "description") or ""

        table.insert(resources, {
            name = name,
            state = state, -- "running", "loaded", "failed to start", "starting", "stopping"
            type = resType,
            author = author,
            version = version,
            description = desc
        })
    end
    return resources
end

-- Start a resource by name
function startServerResource(resourceName)
    if not resourceName or type(resourceName) ~= "string" then
        return { success = false, message = "Invalid resource name specified." }
    end
    local res = getResourceFromName(resourceName)
    if not res then
        return { success = false, message = "Resource '" .. resourceName .. "' does not exist." }
    end
    local currentState = getResourceState(res)
    if currentState == "running" then
        return { success = false, message = "Resource '" .. resourceName .. "' is already running." }
    end
    local started = startResource(res, true)
    if started then
        outputDebugString("[ADMIN-API] Resource '" .. resourceName .. "' started via web panel.")
        return { success = true, message = "Resource '" .. resourceName .. "' started successfully." }
    else
        return { success = false, message = "Failed to start resource '" .. resourceName .. "'." }
    end
end

-- Stop a resource by name
function stopServerResource(resourceName)
    if not resourceName or type(resourceName) ~= "string" then
        return { success = false, message = "Invalid resource name specified." }
    end
    if resourceName == getResourceName(getThisResource()) then
        return { success = false, message = "Cannot stop admin-api resource itself via web panel." }
    end
    local res = getResourceFromName(resourceName)
    if not res then
        return { success = false, message = "Resource '" .. resourceName .. "' does not exist." }
    end
    local currentState = getResourceState(res)
    if currentState ~= "running" then
        return { success = false, message = "Resource '" .. resourceName .. "' is not currently running." }
    end
    local stopped = stopResource(res)
    if stopped then
        outputDebugString("[ADMIN-API] Resource '" .. resourceName .. "' stopped via web panel.")
        return { success = true, message = "Resource '" .. resourceName .. "' stopped successfully." }
    else
        return { success = false, message = "Failed to stop resource '" .. resourceName .. "'." }
    end
end

-- Restart a resource by name
function restartServerResource(resourceName)
    if not resourceName or type(resourceName) ~= "string" then
        return { success = false, message = "Invalid resource name specified." }
    end
    local res = getResourceFromName(resourceName)
    if not res then
        return { success = false, message = "Resource '" .. resourceName .. "' does not exist." }
    end
    local restarted = restartResource(res)
    if restarted then
        outputDebugString("[ADMIN-API] Resource '" .. resourceName .. "' restarted via web panel.")
        return { success = true, message = "Resource '" .. resourceName .. "' restarted successfully." }
    else
        return { success = false, message = "Failed to restart resource '" .. resourceName .. "'." }
    end
end

-- Kick a player by ID or character name
function kickServerPlayer(targetIdOrName, reason)
    reason = reason or "Kicked by Administrator via Web Panel"
    local targetPlayer = nil
    for _, p in ipairs(getElementsByType("player")) do
        local pid = getElementData(p, "playerid")
        if pid and tostring(pid) == tostring(targetIdOrName) then
            targetPlayer = p
            break
        elseif getPlayerName(p) == tostring(targetIdOrName) then
            targetPlayer = p
            break
        end
    end

    if not targetPlayer then
        return { success = false, message = "Player not found." }
    end

    local playerName = getPlayerName(targetPlayer)
    kickPlayer(targetPlayer, reason)
    outputDebugString("[ADMIN-API] Player '" .. playerName .. "' kicked via web panel: " .. reason)
    return { success = true, message = "Player '" .. playerName .. "' has been kicked." }
end

-- Get general server overview
function getServerOverview()
    local totalResources = #getResources()
    local runningCount = 0
    for _, res in ipairs(getResources()) do
        if getResourceState(res) == "running" then
            runningCount = runningCount + 1
        end
    end

    return {
        server_name = getServerName(),
        server_port = getServerPort(),
        mta_version = getVersion().sortable,
        players_online = getPlayerCount(),
        max_players = getMaxPlayers(),
        fps_limit = getFPSLimit(),
        resources_total = totalResources,
        resources_running = runningCount,
        resources_stopped = totalResources - runningCount,
        uptime = getTickCount() / 1000
    }
end

addEventHandler("onResourceStart", resourceRoot, function()
    -- Ensure internal admin account exists for HTTP API
    local acc = getAccount("admin")
    if not acc then
        addAccount("admin", "admin")
        outputDebugString("[ADMIN-API] Created internal 'admin' account for Web API.")
    end

    -- Add to Admin ACL group
    local adminGroup = aclGetGroup("Admin")
    if adminGroup then
        aclGroupAddObject(adminGroup, "user.admin")
        aclGroupAddObject(adminGroup, "resource.admin-api")
    end

    outputDebugString("[ADMIN-API] Web Admin API Bridge loaded successfully.")
end)

