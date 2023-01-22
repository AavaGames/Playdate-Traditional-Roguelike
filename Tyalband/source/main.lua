import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())

	inputManager = InputManager()
	frameProfiler = frameProfiler()
	screenManager = screenManager()
	gameManager = gameManager()

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
		if (gameManager.worldManager.currentWorld.name ~= "Floor 1 (50 feet)") then
			print("Changed world to dungeon")
			gameManager.worldManager:loadWorld(dungeon)
		end
	end
	if inputManager:HeldLong(playdate.kButtonA) and inputManager:HeldLong(playdate.kButtonDown) then
		if (gameManager.worldManager.currentWorld.name ~= "Base Camp") then
			print("Changed world to town")
			gameManager.worldManager:loadWorld(town)
		end
	end

	updateGame()
	drawGame()
end

function playdate.keyPressed(key) 
	if key == "N" then
		local color = screenManager.bgColor == gfx.kColorWhite and gfx.kColorBlack or gfx.kColorWhite
		screenManager:setWorldColor(color)
	end

	if key == "9" then
		if (gameManager.worldManager.currentWorld.name ~= "Floor 1 (50 feet)") then
			print("Changed world to dungeon")
			gameManager.worldManager:loadWorld(dungeon)
		end
	end
	if key == "0" then
		if (gameManager.worldManager.currentWorld.name ~= "Base Camp") then
			print("Changed world to town")
			gameManager.worldManager:loadWorld(town)
		end
	end
end