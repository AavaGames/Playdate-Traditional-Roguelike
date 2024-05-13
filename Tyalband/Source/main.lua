import "~imports"

local gfx <const> = playdate.graphics

local postInitialized = false

local function initialize()

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

-- Called after game is initialized inside playdate.update to allow coroutine yielding
local function postInitialize()
	gameManager.levelManager:postInit()
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

initialize()


function playdate.update()
	if not postInitialized then
		postInitialized = true
		postInitialize()
	end

	playdate.timer.updateTimers()
	updateGame()
	drawGame()
end

---@diagnostic disable-next-line: duplicate-set-field
function playdate.keyPressed(key)
	if key == "n" then
		gameManager.levelManager:loadLevel(Dungeon)
	end
end

function playdate.gameWillTerminate()
	--saveGame()
end

function playdate.deviceWillSleep()
	--saveGame()
end
