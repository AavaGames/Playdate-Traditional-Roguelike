import "global"
import "world"
import "border"

local fps = false;

local gfx <const> = playdate.graphics

local function initializeGame()
	playdate.display.setRefreshRate(targetFPS)
	math.randomseed(playdate.getSecondsSinceEpoch())

	border = border(2,4)
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
end

local function updateGame()
	world:update()
end

local function drawGame()
	gfx.clear()
	gfx.sprite.update()

	world:draw()

	border:draw()
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