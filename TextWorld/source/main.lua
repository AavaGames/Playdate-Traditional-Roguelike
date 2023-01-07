import "global"
import "world"
import "border"
import "logManager"

local fps = false;

local gfx <const> = playdate.graphics

local function initializeGame()
	playdate.display.setRefreshRate(targetFPS)
	math.randomseed(playdate.getSecondsSinceEpoch())

	gfx.setFont(currentFont) 

	gfx.setBackgroundColor(gfx.kColorWhite)

	bgColor = false;
	local function invertColors()
		gfx.setBackgroundColor(bgColor and gfx.kColorBlack or gfx.kColorWhite)
		bgColor = not bgColor
		playdate.timer.performAfterDelay(10000, invertColors)
	end
	--invertColors()

	world = world()
	screenBorder = border(4, 4, 400-8, 240-8, 4, gfx.kColorBlack)

	logBorder = border(10, 162, 400-20, 64, 2, gfx.kColorBlack)

	logManager = logManager()
end

local function updateGame()
	world:update()
	logManager:update()
end

local function drawGame()
	gfx.clear()
	gfx.sprite.update()

	world:draw()
	logManager:draw()

	screenBorder:draw()
	logBorder:draw()
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