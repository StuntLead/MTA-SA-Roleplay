-- // Chaos - Duty allow script (Enhanced GUI by Antigravity)

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end

DutyAllow = {
    label = {},
    edit = {},
    button = {},
    window = {},
    gridlist = {},
    combobox = {}
}

weapBanList = {
	[-8] = true, -- Katana
	[-35] = true, -- RPG
	[-36] = true, -- Homing RPG
	[-37] = true, -- Flamethrower
	[-38] = true, -- Minigun
	[-39] = true, -- C4 Charge
	[-40] = true, -- C4 Det
}

-- Skipped weapon IDs (not real weapons or not usable)
local weapSkipList = { [19] = true, [20] = true, [21] = true }

function createAdminDuty(factionT, dutyT)
	if isElement(DutyAllow.window[1]) then
		destroyElement(DutyAllow.window[1])
	end

	factionTable = factionT
	dutyChanges = dutyT

    -- Main window - wider to fit the picker panel
    DutyAllow.window[1] = guiCreateWindow(300, 150, 900, 500, "Admin Duty Settings", false)
    centerWindow(DutyAllow.window[1])
    guiWindowSetSizable(DutyAllow.window[1], false)
    guiWindowSetMovable(DutyAllow.window[1], true)
    guiSetInputEnabled(true)

    -- ===== TOP ROW: Faction selector + View toggle + Done =====
    DutyAllow.combobox[1] = guiCreateComboBox(10, 25, 280, 998, "Make a faction selection.", false, DutyAllow.window[1])
    exports.global:guiComboBoxAdjustHeight(DutyAllow.combobox[1], #factionT)

    DutyAllow.combobox[2] = guiCreateComboBox(300, 25, 140, 19, "", false, DutyAllow.window[1])
    exports.global:guiComboBoxAdjustHeight(DutyAllow.combobox[2], 2)
    guiComboBoxAddItem(DutyAllow.combobox[2], "Items")
    guiComboBoxAddItem(DutyAllow.combobox[2], "Weapons")
    guiComboBoxSetSelected( DutyAllow.combobox[2], 0 )

    DutyAllow.button[3] = guiCreateButton(790, 25, 100, 35, "Done", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[3], "NormalTextColour", "FFAAAAAA")

    -- ===== LEFT PANEL: Currently allowed items/weapons for this faction =====
    DutyAllow.label[2] = guiCreateLabel(10, 60, 420, 16, "Allowed Items", false, DutyAllow.window[1])
    guiLabelSetHorizontalAlign(DutyAllow.label[2], "center", false)

	DutyAllow.gridlist[1] = guiCreateGridList(10, 78, 420, 310, false, DutyAllow.window[1])
    guiGridListAddColumn(DutyAllow.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Name", 0.4)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Description", 0.5)

    -- Remove button (below left panel)
    DutyAllow.button[2] = guiCreateButton(10, 395, 420, 35, "Remove Selected", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[2], "NormalTextColour", "FFAAAAAA")

    -- ===== RIGHT PANEL: All available items/weapons to pick from =====
    DutyAllow.label[5] = guiCreateLabel(470, 60, 420, 16, "Available to Add", false, DutyAllow.window[1])
    guiLabelSetHorizontalAlign(DutyAllow.label[5], "center", false)

    DutyAllow.gridlist[2] = guiCreateGridList(470, 78, 420, 310, false, DutyAllow.window[1])
    guiGridListAddColumn(DutyAllow.gridlist[2], "ID", 0.1)
    guiGridListAddColumn(DutyAllow.gridlist[2], "Name", 0.45)
    guiGridListAddColumn(DutyAllow.gridlist[2], "Info", 0.45)

    -- Item Value / Max Ammo edit box + Allow button (below right panel)
    DutyAllow.label[4] = guiCreateLabel(470, 398, 80, 25, "Item Value:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[4], "center")
    DutyAllow.edit[2] = guiCreateEdit(555, 395, 100, 28, "1", false, DutyAllow.window[1])
    DutyAllow.button[1] = guiCreateButton(670, 395, 220, 35, "<-- Allow Selected", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[1], "NormalTextColour", "FFAAAAAA")

    -- ===== LEGACY: keep hidden edit[1] for backward compat (not shown in GUI) =====
    DutyAllow.edit[1] = guiCreateEdit(0, 0, 1, 1, "", false, DutyAllow.window[1])
    guiSetVisible(DutyAllow.edit[1], false)
    DutyAllow.label[1] = guiCreateLabel(0, 0, 1, 1, "", false, DutyAllow.window[1])
    guiSetVisible(DutyAllow.label[1], false)
    DutyAllow.label[3] = guiCreateLabel(0, 0, 1, 1, "", false, DutyAllow.window[1])
    guiSetVisible(DutyAllow.label[3], false)

    -- Status label
    DutyAllow.label[6] = guiCreateLabel(10, 440, 880, 20, "Select a faction, then pick Items or Weapons to manage.", false, DutyAllow.window[1])
    guiLabelSetHorizontalAlign(DutyAllow.label[6], "center", false)
    guiLabelSetColor(DutyAllow.label[6], 200, 200, 200)

    -- Placeholder text
    local row = guiGridListAddRow( DutyAllow.gridlist[1] )
    guiGridListSetItemText ( DutyAllow.gridlist[1], row, 2, "Make a faction selection...", false, false )

    local row2 = guiGridListAddRow( DutyAllow.gridlist[2] )
    guiGridListSetItemText ( DutyAllow.gridlist[2], row2, 2, "Make a faction selection...", false, false )

    for k,v in pairs(factionT) do
    	guiComboBoxAddItem( DutyAllow.combobox[1], v[2] )
    end
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[1], toggleFaction)
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[2], toggleView)

    addEventHandler("onClientGUIClick", DutyAllow.button[1], allowItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[2], removeItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[3], closeGUI, false)
    addEventHandler("onClientGUIDoubleClick", DutyAllow.gridlist[2], allowItem, false)
end
addEvent("adminDutyAllow", true)
addEventHandler("adminDutyAllow", resourceRoot, createAdminDuty)

-- Populate the "currently allowed" list (left panel)
function populateList(key) -- Type 1 is weapons, 0 is items
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	guiGridListClear( DutyAllow.gridlist[1] )
	if selection == 0 then -- Items
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) > 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])

				guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["item-system"]:getItemName(v[2]), false, false)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, exports["item-system"]:getItemDescription(v[2], v[3]), false, false)
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	elseif selection == 1 then -- Weapons
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) < 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])
				if tonumber(v[2]) == -100 then
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, "Armor", false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				else
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["item-system"]:getItemName(v[2]), false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				end
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	end
	guiSetText(DutyAllow.edit[2], "1")

	-- Also populate the picker (right panel)
	populatePicker(key)
end

-- Populate the "available to add" picker (right panel)
function populatePicker(factionKey)
	local selection = guiComboBoxGetSelected(DutyAllow.combobox[2])
	guiGridListClear(DutyAllow.gridlist[2])

	-- Build a set of already-allowed IDs for this faction so we can grey them out or skip them
	local alreadyAllowed = {}
	if factionKey and factionTable[factionKey] then
		for k,v in pairs(factionTable[factionKey][3]) do
			alreadyAllowed[tonumber(v[2])] = true
		end
	end

	if selection == 0 then -- Items: iterate all items from item-system
		for id = 1, 300 do
			if exports["item-system"]:isItem(id) then
				if id ~= 16 then -- Skip clothes/skins (handled by faction leaders)
					local row = guiGridListAddRow(DutyAllow.gridlist[2])
					guiGridListSetItemText(DutyAllow.gridlist[2], row, 1, tostring(id), false, true)
					guiGridListSetItemText(DutyAllow.gridlist[2], row, 2, exports["item-system"]:getItemName(id), false, false)
					guiGridListSetItemText(DutyAllow.gridlist[2], row, 3, exports["item-system"]:getItemDescription(id, 1), false, false)
					guiGridListSetItemData(DutyAllow.gridlist[2], row, 1, id)
					-- Mark already-allowed items in green
					if alreadyAllowed[id] then
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 1, 100, 255, 100)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 2, 100, 255, 100)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 3, 100, 255, 100)
					end
				end
			end
		end
	elseif selection == 1 then -- Weapons: iterate GTA weapon IDs 1-46
		-- Add Armor first (special case, ID 100)
		local armorRow = guiGridListAddRow(DutyAllow.gridlist[2])
		guiGridListSetItemText(DutyAllow.gridlist[2], armorRow, 1, "100", false, true)
		guiGridListSetItemText(DutyAllow.gridlist[2], armorRow, 2, "Body Armor", false, false)
		guiGridListSetItemText(DutyAllow.gridlist[2], armorRow, 3, "Protective vest", false, false)
		guiGridListSetItemData(DutyAllow.gridlist[2], armorRow, 1, 100)
		if alreadyAllowed[-100] then
			guiGridListSetItemColor(DutyAllow.gridlist[2], armorRow, 1, 100, 255, 100)
			guiGridListSetItemColor(DutyAllow.gridlist[2], armorRow, 2, 100, 255, 100)
			guiGridListSetItemColor(DutyAllow.gridlist[2], armorRow, 3, 100, 255, 100)
		end

		for id = 1, 46 do
			if not weapSkipList[id] then
				local weapName = getWeaponNameFromID(id)
				if weapName then
					local row = guiGridListAddRow(DutyAllow.gridlist[2])
					guiGridListSetItemText(DutyAllow.gridlist[2], row, 1, tostring(id), false, true)
					guiGridListSetItemText(DutyAllow.gridlist[2], row, 2, weapName, false, false)

					-- Show banned status
					if weapBanList[-id] then
						guiGridListSetItemText(DutyAllow.gridlist[2], row, 3, "BANNED", false, false)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 1, 255, 80, 80)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 2, 255, 80, 80)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 3, 255, 80, 80)
					elseif alreadyAllowed[-id] then
						guiGridListSetItemText(DutyAllow.gridlist[2], row, 3, "Already allowed", false, false)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 1, 100, 255, 100)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 2, 100, 255, 100)
						guiGridListSetItemColor(DutyAllow.gridlist[2], row, 3, 100, 255, 100)
					else
						guiGridListSetItemText(DutyAllow.gridlist[2], row, 3, "", false, false)
					end
					guiGridListSetItemData(DutyAllow.gridlist[2], row, 1, id)
				end
			end
		end
	end
end

function toggleView()
	local item = guiComboBoxGetSelected (DutyAllow.combobox[2])
    guiGridListClear( DutyAllow.gridlist[1] )
    guiGridListClear( DutyAllow.gridlist[2] )

	if item == 1 then -- Weapons
		guiSetText(DutyAllow.label[2], "Allowed Weapons")
		guiSetText(DutyAllow.label[5], "Available Weapons")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Max Ammo")

        guiGridListSetColumnTitle(DutyAllow.gridlist[2], 2, "Weapon Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[2], 3, "Status")

        guiSetText(DutyAllow.label[4], "Max Ammo:")
	elseif item == 0 then -- Items
		guiSetText(DutyAllow.label[2], "Allowed Items")
		guiSetText(DutyAllow.label[5], "Available Items")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Description")

        guiGridListSetColumnTitle(DutyAllow.gridlist[2], 2, "Item Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[2], 3, "Description")

        guiSetText(DutyAllow.label[4], "Item Value:")
	end
	if guiComboBoxGetSelected(DutyAllow.combobox[1]) and guiComboBoxGetSelected(DutyAllow.combobox[1]) > -1 then
		populateList(findFactionID(guiComboBoxGetItemText(DutyAllow.combobox[1], guiComboBoxGetSelected(DutyAllow.combobox[1]))))
	end
end

function toggleFaction()
	local selected = guiComboBoxGetSelected(DutyAllow.combobox[1])
	if selected and selected > -1 then
		populateList(findFactionID(guiComboBoxGetItemText(DutyAllow.combobox[1], selected)))
	end
end

function findFactionID(name)
	for k,v in pairs(factionTable) do
		if v[2] == name then
			return tonumber(k)
		end
	end
end

function closeGUI()
	destroyElement(DutyAllow.window[1])
	guiSetInputEnabled(false)
	triggerServerEvent("dutyAdmin:Save", resourceRoot, factionTable, dutyChanges)
end

function allowItem()
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	local faction = guiComboBoxGetSelected (DutyAllow.combobox[1])
	local maxIndex = getElementData(resourceRoot, "maxIndex")+1

	if not (faction and faction > -1) then
		outputChatBox("Please select a faction first.", 255, 0, 0)
		return
	end

	-- Get the selected item from the picker gridlist (right panel)
	local r, c = guiGridListGetSelectedItem(DutyAllow.gridlist[2])
	if r < 0 then
		outputChatBox("Please select an item or weapon from the Available list on the right.", 255, 0, 0)
		return
	end

	local itemID = guiGridListGetItemData(DutyAllow.gridlist[2], r, 1)
	local itemValue = guiGetText(DutyAllow.edit[2])

	if not tonumber(itemID) then
		outputChatBox("Invalid selection.", 255, 0, 0)
		return
	end

	local factionID = findFactionID(guiComboBoxGetItemText( DutyAllow.combobox[1], faction ))

	if selection == 0 then -- Item
		if not exports['item-system']:isItem(itemID) then
			outputChatBox("That's not a valid item.", 255, 0, 0)
			return
		end
		if tonumber(itemID) == 16 then
			outputChatBox("Skins are supposed to be uploaded by faction leaders while being on faction duty at Dupont HQ.", 255, 0, 0)
			return
		end
		table.insert(factionTable[factionID][3], { maxIndex, tonumber(itemID), itemValue })
		table.insert(dutyChanges, { factionID, 1, maxIndex, tonumber(itemID), itemValue })
		setElementData(resourceRoot, "maxIndex", maxIndex)
		guiSetText(DutyAllow.label[6], "Allowed item: " .. exports["item-system"]:getItemName(itemID) .. " (ID " .. itemID .. ")")
		guiLabelSetColor(DutyAllow.label[6], 100, 255, 100)
	elseif selection == 1 then -- Weapon
		if tonumber(itemValue) then
			if tonumber(itemID) == 100 then
				-- Armor
				table.insert(factionTable[factionID][3], { maxIndex, -100, itemValue })
				table.insert(dutyChanges, { factionID, 1, maxIndex, -100, itemValue })
				setElementData(resourceRoot, "maxIndex", maxIndex)
				guiSetText(DutyAllow.label[6], "Allowed weapon: Body Armor (max " .. itemValue .. ")")
				guiLabelSetColor(DutyAllow.label[6], 100, 255, 100)
			elseif not weapBanList[-tonumber(itemID)] then
				table.insert(factionTable[factionID][3], { maxIndex, -tonumber(itemID), itemValue })
				table.insert(dutyChanges, { factionID, 1, maxIndex, -tonumber(itemID), itemValue })
				setElementData(resourceRoot, "maxIndex", maxIndex)
				local weapName = getWeaponNameFromID(tonumber(itemID)) or "Unknown"
				guiSetText(DutyAllow.label[6], "Allowed weapon: " .. weapName .. " (max ammo " .. itemValue .. ")")
				guiLabelSetColor(DutyAllow.label[6], 100, 255, 100)
			else
				outputChatBox("This weapon is banned from being added.", 255, 0, 0)
				guiSetText(DutyAllow.label[6], "This weapon is BANNED and cannot be added.")
				guiLabelSetColor(DutyAllow.label[6], 255, 80, 80)
			end
		else
			outputChatBox("The Max Ammo must be a number!", 255, 0, 0)
		end
	end
	populateList(factionID)
end

function removeItem()
	local r, c = guiGridListGetSelectedItem ( DutyAllow.gridlist[1] )
	local faction = guiComboBoxGetSelected(DutyAllow.combobox[1])
    if r and r>=-1 and c and c>=-1 and faction and faction >= 0 then
    	local factionID = findFactionID(guiComboBoxGetItemText( DutyAllow.combobox[1], faction ))
    	local id = guiGridListGetItemData(DutyAllow.gridlist[1], r, 1)
    	for k,v in pairs(factionTable[factionID][3]) do
    		if tonumber(id) == tonumber(v[1]) then
    			table.insert(dutyChanges, { factionID, 0, v[1] })
    			table.remove(factionTable[factionID][3], k)
    			guiSetText(DutyAllow.label[6], "Removed entry successfully.")
    			guiLabelSetColor(DutyAllow.label[6], 255, 200, 100)
    			populateList(factionID)
    			return
    		end
    	end
    else
    	outputChatBox("Please make a selection first.", 255, 0, 0)
    end
end
