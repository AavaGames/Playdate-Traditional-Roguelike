class("SettingsMenu").extends()

function SettingsMenu:init()

    self.menu = Menu(self.menuManager, "DEBUG MENU #" .. math.random(0, 1000), {

        MenuItem("Fullscreen Log", nil, true, false, function () 
            gameManager:setFullscreenLog(not gameManager.logManager.fullscreen)
        end),
        
        MenuItem("Centre Camera on Player", nil, true, false, function ()
            gameManager.levelManager.currentLevel.camera:centreOnTarget()
        end),

        

        MenuItem("Fullscreen Log", nil, true, false, function ()
            local logSizeMenu, error = menu:addOptionsMenuItem("log font", { "6px", "8px", "12px" }, "8px", function(value)
                screenManager:setLogFont(value)
            end)
            screenManager:setLogFont(value)
        end),

    })

    -- Bool MenuItem
        -- toggles on/off and changes text
    -- Option MenuItem
        -- Cycles an enum and changes text

end

function SettingMenu:open()
    self.menuManager:addMenu(self.menu)
end