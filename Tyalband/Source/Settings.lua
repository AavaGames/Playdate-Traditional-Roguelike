---@class Settings : Object
---@overload fun(): Settings
Settings = class("Settings").extends() or Settings

function Settings:init()
    self.cameraFollowPlayer = false;
    self.levelFont = "16px"
    self.logFont = "12px"
end