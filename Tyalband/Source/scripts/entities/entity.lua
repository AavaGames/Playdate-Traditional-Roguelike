local gfx <const> = playdate.graphics

class("Entity").extends()

--abstract class
function Entity:init()
    self.char = "E"
    self.name = "Entity"
    self.description = "Default Entity"
end