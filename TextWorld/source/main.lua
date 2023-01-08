import "global"

import "worldManager"
import "logManager"
import "border"

local fps = true;

local gfx <const> = playdate.graphics

local function initializeGame()
	playdate.display.setRefreshRate(targetFPS)
	math.randomseed(playdate.getSecondsSinceEpoch())

	gfx.setFont(baseFont) 

	--print("font height " .. baseFont:getHeight())

	gfx.setBackgroundColor(gfx.kColorWhite)

	bgColor = false;
	local function invertColors()
		gfx.setBackgroundColor(bgColor and gfx.kColorBlack or gfx.kColorWhite)
		bgColor = not bgColor
		playdate.timer.performAfterDelay(10000, invertColors)
	end
	--invertColors()

	worldManager = worldManager()
	logManager = logManager()
end

local function updateGame()
	worldManager:update()
	logManager:update()
end

local function drawGame()
	gfx.clear()
	gfx.sprite.update()

	worldManager:draw()

	-- if playdate.keyPressed("o") then
	-- 	showLog = not showLog
	-- end

	if showLog then
		logManager:draw()
	end
end

initializeGame()

function playdate.update()
	playdate.timer.updateTimers()
	updateGame()
	drawGame()

	if fps then
		playdate.drawFPS(0,0)
	end
end