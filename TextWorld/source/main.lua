import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())

	screenManager = screenManager()
	gameManager = gameManager()
end

local function updateGame()
	gameManager:update()
	gameManager:lateUpdate()
	screenManager:update()
	screenManager:lateUpdate()
end

local function drawGame()
	screenManager:draw()
end

initializeGame()

function playdate.update()
	playdate.timer.updateTimers()
	updateGame()
	drawGame()
end

function playdate.keyPressed(key) 
	if key == "N" then
		screenManager:invertColors()
	end
end