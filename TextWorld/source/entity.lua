import "global"

local gfx <const> = playdate.graphics

class("entity").extends()

--abstract class
function entity:init()
    self.char = "E"
    self.name = "Entity"
    self.description = "Default Entity"
end