local gfx <const> = playdate.graphics

class("Entity").extends()

--abstract class
function Entity:init()
    self.glyph = "E"
    self.name = "Entity"
    self.description = "Default Entity"
end