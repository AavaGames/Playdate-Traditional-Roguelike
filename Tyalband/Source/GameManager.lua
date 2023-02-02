class("GameManager").extends()

function GameManager:init()
	--self.mainMenu = false

	local menu = playdate.getSystemMenu()
    local levelSizeMenu, error = menu:addOptionsMenuItem("level font", { "8px", "10px", "16px" }, "16px", function(value)
		ScreenManager:setLevelFont(value)
    end)

    local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
		ScreenManager:setLogFont(value)
    end)

	self.player = Player()
    self.levelManager = LevelManager(self.player)
	self.logManager = LogManager(self.levelManager)
end

function GameManager:update()
    self.levelManager:update()
	self.logManager:update()
end

function GameManager:lateUpdate()
	self.levelManager:lateUpdate()
end