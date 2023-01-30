import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())
	playdate.display.setRefreshRate(10);
end

local function updateGame()
	
end

local function drawGame()
	--gfx.drawText("We're going that way", 5, 100)
end

initializeGame()

function playdate.update()
	-- playdate.timer.updateTimers()
	local t = chunkTimer("C Update");
	C.Update()
	--t:print();
	updateGame()
	drawGame()

end

function playdate.keyPressed(key) 

end