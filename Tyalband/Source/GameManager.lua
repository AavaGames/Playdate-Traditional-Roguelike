class("GameManager").extends()

function GameManager:init()
	math.randomseed(playdate.getSecondsSinceEpoch()) -- TODO call on new game start

	self.menuManager = MenuManager(self)

	self.player = Player()
    self.levelManager = LevelManager(self.player)
	self.logManager = LogManager(self.levelManager)

	self.gameStates = enum({"level", "fullLog", "menu"})
	self.currentGameState = self.gameStates.level

	self.settingsMenu = SettingsMenu(self.menuManager)
	self.commandMenu = CommandMenu(self.menuManager)

    -- local levelSizeMenu, error = menu:addOptionsMenuItem("level font", { "8px", "10px", "16px" }, "16px", function(value)
	-- 	screenManager:setLevelFont(value)
    -- end)
    -- local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
	-- 	screenManager:setLogFont(value)
    -- end)

	pDebug:createDebugMenu(self.menuManager)
	local sysMenu = playdate.getSystemMenu()
	self.sysSettingsMenu, error = sysMenu:addMenuItem("Settings", function()
        self.settingsMenu:open()
    end)
	self.sysCommandMenu, error = sysMenu:addMenuItem("Commands", function()
        self.commandMenu:open()
    end)
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
	pDebug:log("GameManager State is now = " .. state)
	if self:isState(self.gameStates.level) then
		screenManager:redrawScreen()
	elseif self:isState(self.gameStates.fullLog) then
		screenManager:redrawScreen()
	elseif self:isState(self.gameStates.menu) then

	else
		pDebug:log("ERROR: " .. state .. " is an invalid GameManager state.")
	end
end

function GameManager:isState(state)
	if (state ~= nil) then
		return (self.currentGameState == state)
	else
		pDebug:log("GameManager.isState recieved nil state")
		return false -- error?
	end
end

--#region Sub State Funcs

function GameManager:setFullscreenLog(full)
	self.logManager:setFullscreen(full)
	self:setState(full and self.gameStates.fullLog or self.gameStates.level)
end

--#endregion