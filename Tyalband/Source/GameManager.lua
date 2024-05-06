---@class GameManager
---@overload fun(): GameManager
GameManager = class("GameManager").extends() or GameManager

local GameStates <const> = enum.new({"Level", "FullLog", "Menu"})

function GameManager:init()
	math.randomseed(playdate.getSecondsSinceEpoch()) -- TODO call on new game start

	self.menuManager = MenuManager(function ()
		self:setState(GameStates.Menu)
	end,
	function ()
		if (self:isState(GameStates.Menu)) then
            self:setState(GameStates.Level)
        end
	end)
	screenManager.menuManager = self.menuManager

	self.gameStats = createGameStats()

	pDebug:createDebugMenu(self.menuManager)
	self.settingsMenu = SettingsMenu(self.menuManager)
	self.commandMenu = CommandMenu(self.menuManager)

	local sysMenu = playdate.getSystemMenu()
	self.sysSettingsMenu, error = sysMenu:addMenuItem("Settings", function()
        self.settingsMenu:open()
    end)
	self.sysCommandMenu, error = sysMenu:addMenuItem("Commands", function()
        self.commandMenu:open()
    end)


	self.player = Player(self.menuManager)
    self.levelManager = LevelManager(self.player)
	self.logManager = LogManager(self.levelManager)

	self.GameStates = GameStates
	self.currentGameState = self.GameStates.Level

	self.initialized = true -- used for saving
end

function GameManager:update()
	if self:isState(self.GameStates.Level) then
		self.levelManager:update()
		self.logManager:update()
	elseif self:isState(self.GameStates.FullLog) then
		self.logManager:update()
	elseif self:isState(self.GameStates.Menu) then
		self.menuManager:update()
	end
end

function GameManager:lateUpdate()
	if self:isState(self.GameStates.Level) then
		self.levelManager:lateUpdate()
		self.logManager:lateUpdate()
	elseif self:isState(self.GameStates.FullLog) then
		self.logManager:lateUpdate()
	elseif self:isState(self.GameStates.Menu) then

	end
end

function GameManager:setState(state)
	self.currentGameState = state
	--pDebug:log("GameManager State is now = " .. enum.getName(self.GameStates, state))
	if self:isState(self.GameStates.Level) then
		screenManager:redrawScreen()
	elseif self:isState(self.GameStates.FullLog) then
		screenManager:redrawScreen()
	elseif self:isState(self.GameStates.Menu) then

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
	self:setState(full and self.GameStates.FullLog or self.GameStates.Level)
end

--#endregion