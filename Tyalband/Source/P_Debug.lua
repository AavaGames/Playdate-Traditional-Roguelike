import "CoreLibs/utilities/where"

class("P_Debug").extends()

function P_Debug:init()
    self.debug = true
    self.frameTime = false
    self.profile = false
    self.systemMenuItem = nil
	self.debugMenu = nil
end

function P_Debug:log(text)
    if (self.debug) then
        print(text)
    end
end

function P_Debug:error(text)
    print("ERROR: " .. text .. "\n\t" .. where())
end

function P_Debug:createDebugMenu(menuManager)
    if (self.debugMenu == nil) then
        self.debugMenu = DebugMenu(menuManager)
        self:checkForSysMenu()
    end
end

function P_Debug:checkForSysMenu() -- called from gameManager
    local sysMenu = playdate.getSystemMenu()
	if (self.debug == true) then
        if (self.systemMenuItem == nil) then
            self.systemMenuItem, error = sysMenu:addMenuItem("Debug", function()
                self.debugMenu:open()
            end)
        end
    else
        if (self.systemMenuItem ~= nil) then
            sysMenu:removeMenuItem(self.systemMenuItem)
        end
	end
end