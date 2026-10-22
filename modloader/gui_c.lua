--[[
    ModLoader - Vehicle Mods Manager GUI [F4]
    Allows players to toggle individual vehicle mods or enable/disable all vehicle mods.
]]

local SETTINGS_FILE = "@vehicle_mods.xml"

-- Global tables shared with replacer_c.lua
allVehicleMods = allVehicleMods or {}
vehicleStates = vehicleStates or {}

-- Load saved user preferences from client XML file
function loadVehicleModsSettings()
    local states = {}
    local xml = xmlLoadFile(SETTINGS_FILE)
    if xml then
        local children = xmlNodeGetChildren(xml) or {}
        for _, node in ipairs(children) do
            if xmlNodeGetName(node) == "mod" then
                local name = xmlNodeGetAttribute(node, "name")
                local enabled = xmlNodeGetAttribute(node, "enabled")
                if name then
                    states[name] = (enabled == "true")
                end
            end
        end
        xmlUnloadFile(xml)
    end
    return states
end

-- Save user preferences to client XML file
function saveVehicleModsSettings(states)
    local xml = xmlLoadFile(SETTINGS_FILE)
    if not xml then
        xml = xmlCreateFile(SETTINGS_FILE, "vehicle_mods")
    end
    if xml then
        local children = xmlNodeGetChildren(xml) or {}
        for _, node in ipairs(children) do
            xmlDestroyNode(node)
        end
        for name, enabled in pairs(states) do
            local node = xmlCreateChild(xml, "mod")
            xmlNodeSetAttribute(node, "name", tostring(name))
            xmlNodeSetAttribute(node, "enabled", enabled and "true" or "false")
        end
        xmlSaveFile(xml)
        xmlUnloadFile(xml)
    end
end

-- Enable or disable a single vehicle mod
function setVehicleModEnabled(modName, modelID, enable, isBulk)
    if enable then
        loadMod("vehicles", modName, modelID)
        vehicleStates[modName] = true
        if not isBulk then
            local vehName = getVehicleNameFromModel(modelID) or modName
            outputChatBox("[ModLoader] Enabled mod for: " .. vehName .. " (" .. modName .. ")", 100, 255, 100)
            saveVehicleModsSettings(vehicleStates)
        end
    else
        unloadMod(modelID)
        vehicleStates[modName] = false
        if not isBulk then
            local vehName = getVehicleNameFromModel(modelID) or modName
            outputChatBox("[ModLoader] Disabled mod for: " .. vehName .. " (" .. modName .. ")", 255, 120, 100)
            saveVehicleModsSettings(vehicleStates)
        end
    end
end

----------------------------------------------------------------------------------------------------
-- GUI Setup
----------------------------------------------------------------------------------------------------

local screenW, screenH = guiGetScreenSize()
local windowW, windowH = 540, 450
local posX = math.floor((screenW - windowW) / 2)
local posY = math.floor((screenH - windowH) / 2)

local modWindow = guiCreateWindow(posX, posY, windowW, windowH, "Vehicle Mods Manager [F4]", false)
guiWindowSetSizable(modWindow, false)
guiSetVisible(modWindow, false)

-- Instructions label
local lblInfo = guiCreateLabel(15, 26, windowW - 30, 20, "Select a vehicle mod to toggle, or use Enable All / Disable All below.", false, modWindow)
guiLabelSetColor(lblInfo, 210, 210, 210)

-- Grid list for vehicle mods
local gridMods = guiCreateGridList(15, 50, windowW - 30, 275, false, modWindow)
guiGridListSetSortingEnabled(gridMods, false)

local colVehicle = guiGridListAddColumn(gridMods, "Vehicle", 0.35)
local colModFile = guiGridListAddColumn(gridMods, "Mod File", 0.25)
local colModelID = guiGridListAddColumn(gridMods, "Model ID", 0.16)
local colStatus  = guiGridListAddColumn(gridMods, "Status", 0.20)

-- Status / Counter label
local lblStats = guiCreateLabel(15, 332, windowW - 30, 20, "Total: 0 | Enabled: 0 | Disabled: 0", false, modWindow)
guiSetFont(lblStats, "default-bold-small")

-- Action Buttons (Y = 360, Height = 34)
local btnToggle     = guiCreateButton(15, 360, 125, 34, "Toggle Selected", false, modWindow)
local btnEnableAll  = guiCreateButton(148, 360, 110, 34, "Enable All", false, modWindow)
local btnDisableAll = guiCreateButton(266, 360, 110, 34, "Disable All", false, modWindow)
local btnClose      = guiCreateButton(384, 360, 141, 34, "Close (F4)", false, modWindow)

-- Bottom tip label
local lblHint = guiCreateLabel(15, 408, windowW - 30, 20, "Tip: You can also double-click any row in the list to toggle its status.", false, modWindow)
guiLabelSetColor(lblHint, 140, 140, 140)
guiSetFont(lblHint, "default-small")

----------------------------------------------------------------------------------------------------
-- GUI Population & Refresh
----------------------------------------------------------------------------------------------------

function refreshVehicleList()
    if not isElement(gridMods) then return end

    -- Remember current selected mod so selection doesn't reset
    local selectedRow = guiGridListGetSelectedItem(gridMods)
    local selectedMod = nil
    if selectedRow and selectedRow ~= -1 then
        selectedMod = guiGridListGetItemData(gridMods, selectedRow, colVehicle)
    end

    guiGridListClear(gridMods)

    local total = 0
    local enabledCount = 0
    local disabledCount = 0

    -- Sort vehicle mods alphabetically by vehicle name
    local sorted = {}
    for modName, modelID in pairs(allVehicleMods) do
        table.insert(sorted, { name = modName, id = modelID })
    end
    table.sort(sorted, function(a, b)
        local nameA = getVehicleNameFromModel(a.id) or a.name
        local nameB = getVehicleNameFromModel(b.id) or b.name
        return nameA:lower() < nameB:lower()
    end)

    local restoredRow = nil

    for _, item in ipairs(sorted) do
        local modName = item.name
        local modelID = item.id
        local isEnabled = (vehicleStates[modName] ~= false)
        local vehName = getVehicleNameFromModel(modelID) or "Unknown Vehicle"

        local row = guiGridListAddRow(gridMods)
        guiGridListSetItemText(gridMods, row, colVehicle, vehName, false, false)
        guiGridListSetItemText(gridMods, row, colModFile, modName, false, false)
        guiGridListSetItemText(gridMods, row, colModelID, tostring(modelID), false, true)

        if isEnabled then
            guiGridListSetItemText(gridMods, row, colStatus, "Enabled", false, false)
            guiGridListSetItemColor(gridMods, row, colStatus, 50, 220, 50)
            guiGridListSetItemColor(gridMods, row, colVehicle, 240, 240, 240)
            enabledCount = enabledCount + 1
        else
            guiGridListSetItemText(gridMods, row, colStatus, "Disabled", false, false)
            guiGridListSetItemColor(gridMods, row, colStatus, 230, 60, 60)
            guiGridListSetItemColor(gridMods, row, colVehicle, 150, 150, 150)
            disabledCount = disabledCount + 1
        end

        guiGridListSetItemData(gridMods, row, colVehicle, modName)

        if selectedMod and selectedMod == modName then
            restoredRow = row
        end

        total = total + 1
    end

    if restoredRow then
        guiGridListSetSelectedItem(gridMods, restoredRow, colVehicle)
    end

    guiSetText(lblStats, string.format("Total Vehicle Mods: %d   |   Enabled: %d   |   Disabled: %d", total, enabledCount, disabledCount))
end

----------------------------------------------------------------------------------------------------
-- Button Actions
----------------------------------------------------------------------------------------------------

local function onToggleSelected()
    local selectedRow = guiGridListGetSelectedItem(gridMods)
    if not selectedRow or selectedRow == -1 then
        outputChatBox("[ModLoader] Please select a vehicle mod from the list first.", 255, 180, 0)
        return
    end

    local modName = guiGridListGetItemData(gridMods, selectedRow, colVehicle)
    if not modName then return end
    local modelID = allVehicleMods[modName]
    if not modelID then return end

    local currentState = (vehicleStates[modName] ~= false)
    local newState = not currentState
    setVehicleModEnabled(modName, modelID, newState, false)
    refreshVehicleList()
end

addEventHandler("onClientGUIClick", btnToggle, onToggleSelected, false)

addEventHandler("onClientGUIDoubleClick", gridMods, function(button, state)
    if button == "left" then
        onToggleSelected()
    end
end, false)

addEventHandler("onClientGUIClick", btnEnableAll, function()
    local count = 0
    for modName, modelID in pairs(allVehicleMods) do
        setVehicleModEnabled(modName, modelID, true, true)
        count = count + 1
    end
    saveVehicleModsSettings(vehicleStates)
    refreshVehicleList()
    outputChatBox("[ModLoader] All vehicle mods (" .. count .. ") have been enabled.", 100, 255, 100)
end, false)

addEventHandler("onClientGUIClick", btnDisableAll, function()
    local count = 0
    for modName, modelID in pairs(allVehicleMods) do
        setVehicleModEnabled(modName, modelID, false, true)
        count = count + 1
    end
    saveVehicleModsSettings(vehicleStates)
    refreshVehicleList()
    outputChatBox("[ModLoader] All vehicle mods (" .. count .. ") have been disabled (default models restored).", 255, 150, 100)
end, false)

addEventHandler("onClientGUIClick", btnClose, function()
    toggleVehicleModsGUI()
end, false)

----------------------------------------------------------------------------------------------------
-- Window Toggle & Keybinds
----------------------------------------------------------------------------------------------------

function toggleVehicleModsGUI()
    if not isElement(modWindow) then return end

    -- Avoid opening while player is typing in chat or console
    if isChatBoxInputActive() or isConsoleActive() then
        return
    end

    local isVisible = guiGetVisible(modWindow)
    local newState = not isVisible

    guiSetVisible(modWindow, newState)
    showCursor(newState)

    if newState then
        guiBringToFront(modWindow)
        refreshVehicleList()
        -- If mods table is empty, request replacements from server
        if not next(allVehicleMods) then
            triggerServerEvent("requestReplacements", localPlayer)
        end
    end
end

bindKey("F4", "down", toggleVehicleModsGUI)
addCommandHandler("vehmods", toggleVehicleModsGUI)
addCommandHandler("vmods", toggleVehicleModsGUI)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if isElement(modWindow) and guiGetVisible(modWindow) then
        showCursor(false)
    end
end)
