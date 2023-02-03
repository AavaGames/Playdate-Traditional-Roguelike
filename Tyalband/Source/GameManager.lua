class("GameManager").extends()

function GameManager:init()
	--self.mainMenu = false

	local menu = playdate.getSystemMenu()
    local levelSizeMenu, error = menu:addOptionsMenuItem("level font", { "8px", "10px", "16px" }, "16px", function(value)
		screenManager:setLevelFont(value)
    end)

    local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
		screenManager:setLogFont(value)
    end)

	local debugMenu, error = menu:addMenuItem("Debug", function()
        self:createDebugMenu()
    end)

	self.menuManager = MenuManager(self)

	self.player = Player()
    self.levelManager = LevelManager(self.player)
	self.logManager = LogManager(self.levelManager)

	self.gameStates = enum({"level", "menu"})
	self.currentGameState = self.gameStates.level
end

function GameManager:update()
	if (self.currentGameState == self.gameStates.level) then
		self.levelManager:update()
		self.logManager:update()
	elseif (self.currentGameState == self.gameStates.menu) then
		self.menuManager:update()
	end
end

function GameManager:lateUpdate()
	if (self.currentGameState == self.gameStates.level) then
		self.levelManager:lateUpdate()
	elseif (self.currentGameState == self.gameStates.menu) then

	end
end

function GameManager:setState(state)
	self.currentGameState = state

	if (self.currentGameState == self.gameStates.level) then
		screenManager:redrawScreen()
	elseif (self.currentGameState == self.gameStates.menu) then

	else
		print("ERROR: " .. state .. " is an invalid GameManager state.")
	end
end

function GameManager:createDebugMenu()
	self.menuManager:addMenu(
        Menu(self.menuManager, "DEBUG", {
			{ text = "Centre Camera on Player", closeMenuOnExecution = true, func = function() 
				gameManager.levelManager.currentLevel.camera:centreOnTarget()
			end },
            { text = "Load Town", closeMenuOnExecution = true, func = function() 
				if (gameManager.levelManager.currentLevel.name ~= "Base Camp") then
					print("Changed level to town")
					gameManager.levelManager:loadLevel(Town, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end },
			{ text = "Load Dungeon", closeMenuOnExecution = true, func = function() 
				if (gameManager.levelManager.currentLevel.name ~= "Floor 1 (50 feet)") then
					print("Changed level to dungeon")
					gameManager.levelManager:loadLevel(Dungeon, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end },
			{ text = "Load Test Room", closeMenuOnExecution = true, func = function() 
				if (gameManager.levelManager.currentLevel.name ~= "Testing Room") then
					print("Changed level to dungeon")
					gameManager.levelManager:loadLevel(TestRoom, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end },
			{ text = "Toggle BG Color", closeMenuOnExecution = true, func = function() 
				screenManager:setBGColor(screenManager.bgColor == playdate.graphics.kColorWhite and playdate.graphics.kColorBlack or playdate.graphics.kColorWhite)
			end },
			{ text = "Nested Debug Menu", closeMenuOnExecution = false, func = function() self:createDebugMenu() end }
		})
    )
end