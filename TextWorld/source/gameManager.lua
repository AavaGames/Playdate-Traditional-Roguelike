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
	self.logManager = logManager()	
end

function gameManager:update()
	-- if playdate.keyPressed("o") then
	-- 	showLog = not showLog
	-- end

    self.worldManager:update()
	if showLog then
		self.logManager:update()
	end
end

function gameManager:lateUpdate()

end

function gameManager:draw()
	self.worldManager:draw()
	if showLog then
		self.logManager:draw()
	end
end