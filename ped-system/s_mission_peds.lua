--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
]]

--[[
	Mission ped conversation handlers.

	These events are triggered from the client (ped-system/c_peds_rightclick.lua and
	gatekeepers-system/c_ped_rightclick.lua) when a player clicks "Talk" on a mission ped
	(Steven Pullman, Hunter, Rook, Clarice).

	The mission conversation system itself is not implemented yet, so these handlers are
	placeholders: they register the events server-side (which fixes the
	"event is not added serverside" error and keeps the existing client wiring intact) and
	give you a single place to add the mission logic later.

	Inside the handler: source/client is the player who triggered the conversation.
]]

local function startMissionConvo()
	-- TODO: implement the mission conversation (currently a placeholder).
end

for _, eventName in ipairs({ "startStevieConvo", "startHunterConvo", "startRookConvo", "startClariceConvo" }) do
	addEvent(eventName, true)
	addEventHandler(eventName, getRootElement(), startMissionConvo)
end
