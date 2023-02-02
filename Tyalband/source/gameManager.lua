class("GameManager").extends()

function GameManager:init()
	--self.mainMenu = false

	local menu = playdate.getSystemMenu()
    local worldSizeMenu, error = menu:addOptionsMenuItem("world font", { "8px", "10px", "16px" }, "16px", function(value)
		ScreenManager:setWorldFont(value)
    end)

    local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
		ScreenManager:setLogFont(value)
    end)

	self.player = Player()
    self.worldManager = WorldManager(self.player)
	self.logManager = LogManager(self.worldManager)
end

function GameManager:update()
    self.worldManager:update()
	self.logManager:update()
end

function GameManager:lateUpdate()
	self.worldManager:lateUpdate()
end