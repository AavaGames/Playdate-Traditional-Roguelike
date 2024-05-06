import "CoreLibs/utilities/where"

---@class P_Debug : Object
---@overload fun(): P_Debug
P_Debug = class("P_Debug").extends() or P_Debug

function P_Debug:init()
    self.debug = true

    self.frameTime = false
    self.profile = false
    self.menu = nil
end

---@param text string
function P_Debug:log(text)
    if (self.debug) then
        print(text)
    end
end

---@param text string
function P_Debug:error(text)
    print("ERROR: " .. text .. "\n\t" .. where())
    -- TODO write to a log file for players to send bug reports
end

---@param menuManager MenuManager
function P_Debug:createDebugMenu(menuManager)
    if (self.menu == nil) then
        self.menu = DebugMenu(menuManager)
    end
end