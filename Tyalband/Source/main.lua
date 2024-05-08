import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()

	pDebug = P_Debug()
	frameProfiler = FrameProfiler()
	frameProfiler:frameStart()
	frameProfiler:startTimer("Initialization")

	settings = Settings()
	inputManager = InputManager()
	screenManager = ScreenManager()
	
	gameManager = GameManager()

	-- local v1 = Vector2.new(15, 10)
	-- local v2 = Vector2.new(32, 15)
	-- local v3 = Vector2.new(8, 12)

	--pDebug:log(Test-C(true))

	--Test_Lua()

	frameProfiler:endTimer("Initialization")
	frameProfiler:endFrame(true)
end

local function updateGame()
	frameProfiler:frameStart()
	frameProfiler:startTimer("Logic")

	inputManager:update()

	gameManager:update()
	gameManager:lateUpdate()
	screenManager:update()
	screenManager:lateUpdate()

	inputManager:lateUpdate()

	frameProfiler:endTimer("Logic")
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

---@diagnostic disable-next-line: duplicate-set-field
function playdate.keyPressed(key)
	if key == "n" then

	end
end

function playdate.gameWillTerminate()
	--saveGame()
end

function playdate.deviceWillSleep()
	--saveGame()
end
