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

	if inputManager:HeldLong(playdate.kButtonA) and inputManager:HeldLong(playdate.kButtonUp) then
		if (gameManager.levelManager.currentLevel.name ~= "Floor 1 (50 feet)") then
			print("Changed level to dungeon")
			gameManager.levelManager:loadLevel(Dungeon)
		end
	end
	if inputManager:HeldLong(playdate.kButtonA) and inputManager:HeldLong(playdate.kButtonDown) then
		if (gameManager.levelManager.currentLevel.name ~= "Base Camp") then
			print("Changed level to town")
			gameManager.levelManager:loadLevel(Town)
		end
	end

	updateGame()
	drawGame()
end

function playdate.keyPressed(key) 
	if key == "N" then
		local color = screenManager.bgColor == gfx.kColorWhite and gfx.kColorBlack or gfx.kColorWhite
		screenManager:setLevelColor(color)
	end

	if key == "9" then
		if (gameManager.levelManager.currentLevel.name ~= "Floor 1 (50 feet)") then
			print("Changed level to dungeon")
			gameManager.levelManager:loadLevel(dungeon)
		end
	end
	if key == "0" then
		if (gameManager.levelManager.currentLevel.name ~= "Base Camp") then
			print("Changed level to town")
			gameManager.levelManager:loadLevel(town)
		end
	end
end