class("gameManager").extends()

function gameManager.init()

    bgColor = false;
	local function invertColors()
		gfx.setBackgroundColor(bgColor and gfx.kColorBlack or gfx.kColorWhite)
		bgColor = not bgColor
		playdate.timer.performAfterDelay(10000, invertColors)
	end
	--invertColors()

    worldManager = worldManager()
	logManager = logManager()
end

function gameManager:update()
    worldManager:update()
	logManager:update()

    -- if playdate.keyPressed("o") then
	-- 	showLog = not showLog
	-- end
end

function gameManager:lateUpdate()

end

function gameManager:draw()
    worldManager:draw()
    if showLog then
		logManager:draw()
	end
end