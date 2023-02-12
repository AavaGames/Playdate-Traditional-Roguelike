class("SettingsMenu").extends()

function SettingsMenu:init(menuManager)
    self.menuManager = menuManager
    self.menu = Menu(menuManager, "SETTINGS", {

        MenuItemOptions("Level Font", nil, false, false, false, { "8px", "10px", "16px" }, 3, function (option)
			screenManager:setLevelFont(option)
		end),

		MenuItemOptions("Log Font", nil, false, false, false, { "6px", "8px", "12px" }, 2, function (option)
			screenManager:setLogFont(option)
		end),

        MenuItemBool("Camera Always Follows Character", nil, true, false, false, false, function (bool)
			settings.cameraFollowPlayer = bool
		end),
    })

end

function SettingsMenu:open()
    self.menuManager:addMenu(self.menu)
end