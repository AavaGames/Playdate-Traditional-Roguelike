import "global"
import "world"
import "border"
import "logManager"

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

	world = world()
	screenBorder = border(2, 2, 400-8, 240-8, 4, gfx.kColorBlack)
	logManager = logManager()
end

local function updateGame()
	-- playdate.keyPressed() -- use kb input for debugging

	world:update()
	logManager:update()
end

local function drawGame()
	gfx.clear()
	gfx.sprite.update()

	world:draw()
	if showLog then
		logManager:draw()
	end

	screenBorder:draw()
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