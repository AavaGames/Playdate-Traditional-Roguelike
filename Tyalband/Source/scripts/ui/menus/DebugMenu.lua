class("DebugMenu").extends()

function DebugMenu:init(menuManager)

    self.menuManager = menuManager
    self.menu = Menu(self.menuManager, "DEBUG MENU #" .. math.random(0, 1000), {

		MenuItemBool("Debug profile", nil, true, false, false, true, function (bool)
			pDebug.profile = bool
            pDebug:checkForSysMenu()
		end),

		MenuItemBool("Block Draw", nil, true, true, false, false, function (bool)
			screenManager.debugViewportBlocksDraw = bool
		end),

		MenuItem("Load *Town*", nil, true, true, true, function () 
			if (gameManager.levelManager.currentLevel.name ~= "Base Camp") then
				pDebug:log("Changed level to town")
				gameManager.levelManager:loadLevel(Town, true)
			else
				gameManager.logManager:add("Already at level")
			end
		end),

		MenuItem("Load Dungeon", nil, true, true, true, function () 
			if (gameManager.levelManager.currentLevel.name ~= "Floor 1 (50 feet)") then
				pDebug:log("Changed level to dungeon")
				gameManager.levelManager:loadLevel(Dungeon, true)
			else
				gameManager.logManager:add("Already at level")
			end
		end),
		
		MenuItem("Load Test Room", nil, true, true, true, function () 
			if (gameManager.levelManager.currentLevel.name ~= "Testing Room") then
				pDebug:log("Changed level to dungeon")
				gameManager.levelManager:loadLevel(TestRoom, true)
			else
				gameManager.logManager:add("Already at level")
			end
		end),

		MenuItem("Toggle BG Color", nil, true, true, false, function () 
			screenManager:setBGColor(screenManager.bgColor == playdate.graphics.kColorWhite and playdate.graphics.kColorBlack or playdate.graphics.kColorWhite)
		end),

		-- MenuItem("Nest Another Debug Menu", nil, true, false, false, function ()
		-- 	pDebug.log("i didnt re add this")
		-- end),

		MenuItem("Close All Menus", "Z", true, true, true, function () end),

		MenuItem("Padding 1", nil, true, true, true, function () end),
		MenuItem("Padding 2", "Z", true, true, true, function () end),
		MenuItem("Padding 3", nil, true, true, true, function () end),
		MenuItem("Padding 4", nil, true, true, true, function () end),
		MenuItem("Padding 5", "Z", true, true, true, function () end),
		MenuItem("Padding 6", "Z", true, true, true, function () end),
		MenuItem("Padding 7", "Z", true, true, true, function () end),
		MenuItem("Padding 8", nil, true, true, true, function () end),
		MenuItem("Padding 9", "Z", true, true, true, function () end),
		MenuItem("Padding 10", "Z", true, true, true, function () end),
		MenuItem("Padding 11", "Z", true, true, true, function () end),
		MenuItem("Padding 12", "Z", true, true, true, function () end),
		MenuItem("Padding 13", "Z", true, true, true, function () end),
		MenuItem("Padding 14", nil, true, true, true, function () end),
		MenuItem("Padding 15", nil, true, true, true, function () end),
		MenuItem("Padding 16", nil, true, true, true, function () end),
		MenuItem("Padding 17", "Z", true, true, true, function () end),
		MenuItem("Padding 18", "Z", true, true, true, function () end),

	})

end

function DebugMenu:open()
    self.menuManager:addMenu(self.menu)
end