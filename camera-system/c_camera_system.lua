-- ==========================================================================
-- Speedcam capture flash
-- A bright white "bloom" that fades in fast and fades back out immediately,
-- letting the violator know their picture has just been taken.
-- ==========================================================================
local flashStart = 0        -- getTickCount() when the current flash began (0 = inactive)
local flashRunning = false  -- whether the onClientRender handler is currently attached

local FLASH_FADE_IN = 60    -- ms  -> the white bloom fades in
local FLASH_HOLD = 40       -- ms  -> brief hold at peak brightness
local FLASH_FADE_OUT = 350  -- ms  -> the bloom fades back out
local FLASH_DURATION = FLASH_FADE_IN + FLASH_HOLD + FLASH_FADE_OUT
local FLASH_PEAK_ALPHA = 240

local function drawCaptureFlash()
	if flashStart == 0 then
		return
	end

	local elapsed = getTickCount() - flashStart

	if elapsed >= FLASH_DURATION then
		flashStart = 0
		flashRunning = false
		removeEventHandler("onClientRender", root, drawCaptureFlash)
		return
	end

	-- Work out the current opacity of the white bloom.
	local alpha
	if elapsed < FLASH_FADE_IN then
		-- Bloom fades in.
		alpha = (elapsed / FLASH_FADE_IN) * FLASH_PEAK_ALPHA
	elseif elapsed < FLASH_FADE_IN + FLASH_HOLD then
		-- Hold the peak for a split second.
		alpha = FLASH_PEAK_ALPHA
	else
		-- Bloom fades out (ease-out so it lingers just a little).
		local progress = (elapsed - FLASH_FADE_IN - FLASH_HOLD) / FLASH_FADE_OUT
		alpha = FLASH_PEAK_ALPHA * ((1 - progress) * (1 - progress))
	end

	local screenWidth, screenHeight = guiGetScreenSize()
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(255, 255, 255, math.floor(alpha)), true)
end

function cameraEffect()
	-- (Re)start the flash and make sure the render handler is running.
	flashStart = getTickCount()
	if not flashRunning then
		flashRunning = true
		addEventHandler("onClientRender", root, drawCaptureFlash)
	end
end
addEvent("speedcam:cameraEffect", true)
addEventHandler("speedcam:cameraEffect", getRootElement(), cameraEffect)

function beep()
	local sound = playSound("beep-24.mp3") --Play the beep
	setSoundVolume(sound, 0.7) -- set the sound volume to 70%
end
addEvent("beep", true)
addEventHandler("beep", getRootElement(), beep)