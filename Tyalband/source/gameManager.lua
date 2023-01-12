class("gameManager").extends()

function gameManager:init()
	--self.mainMenu = false

	local menu = playdate.getSystemMenu()
    local worldSizeMenu, error = menu:addOptionsMenuItem("world font", { "8px", "10px", "16px" }, "16px", function(value)
		screenManager:setWorldFont(value)
    end)

    local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
		screenManager:setLogFont(value)
    end)

	self.player = player()
    self.worldManager = worldManager(self.player)
	self.logManager = logManager(self.worldManager)
end

function gameManager:update()
    self.worldManager:update()
	self.logManager:update()
end

function gameManager:lateUpdate()
	self.worldManager:lateUpdate()
end