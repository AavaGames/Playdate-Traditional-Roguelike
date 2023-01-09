class("wall").extends(actor)

function wall:init(theWorld, x, y)
    wall.super.init(self, theWorld, x, y)
    self.char = "M"
    self.name = "Wall"
    self.description = "A cold wall."
end

function wall:update()
    wall.super.update(self)
end