---@class CommandMenu
---@overload fun(menuManager: MenuManager): CommandMenu
CommandMenu = class("CommandMenu").extends() or CommandMenu

function CommandMenu:init(menuManager)

    self.showing = false -- TODO keep track of showing, so multiple arent opened
    self.menuManager = menuManager
    self.menu = Menu(menuManager, "COMMANDS", screenManager.menuFont, {

        MenuItem("Centre Camera on Player", nil, true, true, false, function ()
			gameManager.levelManager.currentLevel.camera:centreOnTarget()
		end),

		MenuItem("Fullscreen Log", nil, true, true, false, function () 
			gameManager:setFullscreenLog(not gameManager.logManager.fullscreen)
		end),

    })

end

function CommandMenu:open()
    self.menuManager:addMenu(self.menu)
end