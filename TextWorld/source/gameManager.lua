class("gameManager").extends()

function gameManager:init()
	--self.mainMenu = false
	
    self.bgColor = false;
	local function invertColors()
		gfx.setBackgroundColor(self.bgColor and gfx.kColorBlack or gfx.kColorWhite)
		self.bgColor = not self.bgColor
		playdate.timer.performAfterDelay(10000, invertColors)
	end
	--invertColors()

	local menu = playdate.getSystemMenu()
    local worldSizeMenu, error = menu:addOptionsMenuItem("world font", { "8px", "10px", "16px" }, "16px", function(value)
		if value == "8px" then
			fontSize = 8
			worldFont = worldFont_8px
			
		elseif value == "10px" then
			fontSize = 10
			worldFont = worldFont_10px

		elseif value == "16px" then
			fontSize = 16
			worldFont = worldFont_16px
		end
		xMax = screenDimensions.x / fontSize
		yMax = screenDimensions.y / fontSize
		self.worldManager.currentWorld.redrawWorld = true
    end)

    local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
		if value == "6px" then
			logFont = logFont_6px
		elseif value == "8px" then
			logFont = logFont_8px
		elseif value == "12px" then
			logFont = logFont_12px
		end
		self.worldManager.currentWorld.redrawWorld = true
    end)
	

	self.player = player()
    self.worldManager = worldManager(self.player)
	self.logManager = logManager(self.worldManager)
end

function gameManager:update()
	-- if playdate.keyPressed("o") then
	-- 	showLog = not showLog
	-- end

    self.worldManager:update()
	self.logManager:update()
end

function gameManager:lateUpdate()
	self.worldManager:lateUpdate()
end

function gameManager:draw()
	self.worldManager:draw()
	self.logManager:draw()
end