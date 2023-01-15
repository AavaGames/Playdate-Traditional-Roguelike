import "~imports"

local gfx <const> = playdate.graphics

local function initializeGame()
	math.randomseed(playdate.getSecondsSinceEpoch())

	screenManager = screenManager()
	gameManager = gameManager()


	-- CSV to 2D table --

	--local timer = chunkTimer("reading ")

	-- local file = playdate.file.open("/assets/filesmonsters.csv")
	-- assert(f, "no csv")

	-- local fileTable = {}
	-- local i = 1
	-- while true do
	-- 	local line = f:readline()
	-- 	fileTable[i] = {}
	-- 	if line ~= nil then
	-- 		for str in string.gmatch(line, "([^,]+)") do
    --             table.insert(fileTable[i], str)
    --     	end
	-- 		print(fileTable[i])
	-- 	else
	-- 		break
	-- 	end
	-- 	i += 1
	-- end
	-- printTable(fileTable)

	--timer:print()
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