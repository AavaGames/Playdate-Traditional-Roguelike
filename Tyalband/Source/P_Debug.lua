import "CoreLibs/utilities/where"

class("P_Debug").extends()

function P_Debug:init()
    self.debug = true

    self.frameTime = false
    self.profile = false
    self.menu = nil
end

function P_Debug:log(text)
    if (self.debug) then
        print(text)
    end
end

function P_Debug:error(text)
    print("ERROR: " .. text .. "\n\t" .. where())
    -- TODO write to a log file for players to send bug reports
end

function P_Debug:createDebugMenu(menuManager)
    if (self.menu == nil) then
        self.menu = DebugMenu(menuManager)
    end
end