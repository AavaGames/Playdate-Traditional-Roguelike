---@class SettingsMenu : Object
---@overload fun(menuManager: MenuManager): SettingsMenu
SettingsMenu = class("SettingsMenu").extends() or SettingsMenu

function SettingsMenu:init(menuManager)
    self.menuManager = menuManager

	local items = {
		MenuItemOptions("Level Font", nil, false, false, false, { "8px", "10px", "16px" }, 3, function (option)
			screenManager:setLevelFont(option)
		end),

		MenuItemOptions("Log Font", nil, false, false, false, { "6px", "8px", "12px" }, 2, function (option)
			screenManager:setLogFont(option)
		end),

        MenuItemBool("Center Camera on Character", nil, true, false, false, false, function (bool)
			settings.cameraFollowPlayer = bool
			if (bool == true) then gameManager.levelManager.currentLevel.camera:centreOnTarget() end
		end),

		MenuItemBool("Pick Up Automatically", nil, true, false, false, true, function (bool) end),
	}

	if (pDebug.debug) then
		table.insert(items, MenuItem("Debug Menu", "1", true, false, false, function ()
			pDebug.menu:open()
		end))
	end

    self.menu = Menu(menuManager, "SETTINGS", screenManager.menuFont, items)
end

function SettingsMenu:open()
    self.menuManager:addMenu(self.menu)
end