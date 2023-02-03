import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())

	inputManager = InputManager()
	frameProfiler = FrameProfiler()
	screenManager = ScreenManager()
	gameManager = GameManager()

	-- local v1 = Vector2.new(15, 10)
	-- local v2 = Vector2.new(32, 15)
	-- local v3 = Vector2.new(8, 12)

	--print(Test-C(true))

	--Test_Lua()
end

local function updateGame()
	frameProfiler:frameStart()
	frameProfiler:startTimer("Logic")

	gameManager:update()
	gameManager:lateUpdate()
	screenManager:update()
	screenManager:lateUpdate()

	frameProfiler:endTimer("Logic")
end

local function drawGame()
	screenManager:draw()
end

initializeGame()

function playdate.update()
	-- playdate.timer.updateTimers()
	inputManager:update()

	updateGame()
	drawGame()
end

function playdate.keyPressed(key) 
	if key == "N" then
		screenManager:setBGColor(screenManager.bgColor == gfx.kColorWhite and gfx.kColorBlack or gfx.kColorWhite)
	end
end