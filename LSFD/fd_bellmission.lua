local fireModel = 2023

function startTheFire (fX,fY,fZ)
    setTimer ( function()
		createFire(fX,fY,fZ,60)
	end, 420000, 1)
    outputDebugString("Creating Fire at x:"..fX.." y:"..fY.." z:"..fZ)
	
    local Soundone = playSound3D( "alarm/firealarm.mp3", 1225, -1428, 13, false )
    setSoundMinDistance(Soundone, 25)
    setSoundMaxDistance(Soundone, 70)
	
	local Soundtwo = playSound3D( "alarm/firealarmsecond.mp3", 1225, -1428, 13, false )
	setSoundMinDistance(Soundtwo, 25)
    setSoundMaxDistance(Soundtwo, 70)
	
    outputDebugString("Playing LSFD alarm ...")
    -- setSoundVolume( Sound, 1 )

	local fire = engineLoadDFF("fire.dff",1)
	engineReplaceModel(fire,fireModel)
end
addEvent("startTheFire",true)
addEventHandler( "startTheFire", getRootElement(), startTheFire)
