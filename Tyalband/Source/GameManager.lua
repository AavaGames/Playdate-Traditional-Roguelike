class("GameManager").extends()

function GameManager:init()
	math.randomseed(playdate.getSecondsSinceEpoch()) -- TODO call on new game start

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
	-- local settingsMenu, error = menu:addMenuItem("Settings", function()
    --     self:createSettingsMenu()
    -- end)

	self.menuManager = MenuManager(self)

	self.player = Player()
    self.levelManager = LevelManager(self.player)
	self.logManager = LogManager(self.levelManager)

	self.gameStates = enum({"level", "fullLog", "menu"})
	self.currentGameState = self.gameStates.level

	MenuItem("Centre Camera on Player", false, false, function () end)
end

function GameManager:update()
	if self:isState(self.gameStates.level) then
		self.levelManager:update()
		self.logManager:update()
	elseif self:isState(self.gameStates.fullLog) then
		self.logManager:update()
	elseif self:isState(self.gameStates.menu) then
		self.menuManager:update()
	end
end

function GameManager:lateUpdate()
	if self:isState(self.gameStates.level) then
		self.levelManager:lateUpdate()
		self.logManager:lateUpdate()
	elseif self:isState(self.gameStates.fullLog) then
		self.logManager:lateUpdate()
	elseif self:isState(self.gameStates.menu) then

	end
end

function GameManager:setState(state)
	self.currentGameState = state
	print("GameManager State is now = " .. state)
	if self:isState(self.gameStates.level) then
		screenManager:redrawScreen()
	elseif self:isState(self.gameStates.fullLog) then
		screenManager:redrawScreen()
	elseif self:isState(self.gameStates.menu) then

	else
		print("ERROR: " .. state .. " is an invalid GameManager state.")
	end
end

function GameManager:isState(state)
	if (state ~= nil) then
		return (self.currentGameState == state)
	else
		print("GameManager.isState recieved nil state")
		return false -- error?
	end
end

--#region Sub State Funcs

function GameManager:setFullscreenLog(full)
	self.logManager:setFullscreen(full)
	self:setState(full and self.gameStates.fullLog or self.gameStates.level)
end

--#endregion

function GameManager:createDebugMenu()
	self.menuManager:addMenu(
        Menu(self.menuManager, "DEBUG MENU #" .. math.random(0, 1000), {

			MenuItem("Centre Camera on Player", nil, true, false, function ()
				gameManager.levelManager.currentLevel.camera:centreOnTarget()
			end),


			
			MenuItem("Fullscreen Log", nil, true, false, function () 
				gameManager:setFullscreenLog(not gameManager.logManager.fullscreen)
			end),

			MenuItem("Load *Town*", nil, true, true, function () 
				if (gameManager.levelManager.currentLevel.name ~= "Base Camp") then
					print("Changed level to town")
					gameManager.levelManager:loadLevel(Town, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end),

			MenuItem("Load Dungeon", nil, true, true, function () 
				if (gameManager.levelManager.currentLevel.name ~= "Floor 1 (50 feet)") then
					print("Changed level to dungeon")
					gameManager.levelManager:loadLevel(Dungeon, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end),
			
			MenuItem("Load Test Room", nil, true, true, function () 
				if (gameManager.levelManager.currentLevel.name ~= "Testing Room") then
					print("Changed level to dungeon")
					gameManager.levelManager:loadLevel(TestRoom, true)
				else
					gameManager.logManager:add("Already at level")
				end
			end),

			MenuItem("Toggle BG Color", nil, false, false, function () 
				screenManager:setBGColor(screenManager.bgColor == playdate.graphics.kColorWhite and playdate.graphics.kColorBlack or playdate.graphics.kColorWhite)
			end),

			MenuItem("Nest Another Debug Menu", nil, false, false, function () 
				gameManager:createDebugMenu()
			end),

			MenuItem("Close All Menus", "Z", true, true, function () end),

			MenuItem("Padding 1", nil, true, true, function () end),
			MenuItem("Padding 2", "Z", true, true, function () end),
			MenuItem("Padding 3", nil, true, true, function () end),
			MenuItem("Padding 4", nil, true, true, function () end),
			MenuItem("Padding 5", "Z", true, true, function () end),
			MenuItem("Padding 6", "Z", true, true, function () end),
			MenuItem("Padding 7", "Z", true, true, function () end),
			MenuItem("Padding 8", nil, true, true, function () end),
			MenuItem("Padding 9", "Z", true, true, function () end),
			MenuItem("Padding 10", "Z", true, true, function () end),
			MenuItem("Padding 11", "Z", true, true, function () end),
			MenuItem("Padding 12", "Z", true, true, function () end),
			MenuItem("Padding 13", "Z", true, true, function () end),
			MenuItem("Padding 14", nil, true, true, function () end),
			MenuItem("Padding 15", nil, true, true, function () end),
			MenuItem("Padding 16", nil, true, true, function () end),
			MenuItem("Padding 17", "Z", true, true, function () end),
			MenuItem("Padding 18", "Z", true, true, function () end),

			-- 26 items total
		})
    )
end