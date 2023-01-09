import "global"

local gfx <const> = playdate.graphics

local function initializeGame()
	playdate.display.setRefreshRate(targetFPS)
	math.randomseed(playdate.getSecondsSinceEpoch())
	gfx.setBackgroundColor(gfx.kColorWhite)

	gameManager = gameManager()
end

local function updateGame()
	gameManager:update()
	gameManager:lateUpdate()
end

local function drawGame()
	gfx.clear()
	gfx.sprite.update()

	gameManager:draw()
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