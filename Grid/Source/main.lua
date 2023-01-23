import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())
end

local function updateGame()
	
end

local function drawGame()
	gfx.drawText("We're going that way", 5, 100)
end

initializeGame()

function playdate.update()
	-- playdate.timer.updateTimers()
	updateGame()
	drawGame()
end

function playdate.keyPressed(key) 

end