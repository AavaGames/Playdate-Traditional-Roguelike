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