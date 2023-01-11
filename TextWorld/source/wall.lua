class("wall").extends(actor)

function wall:init(theWorld, startPosition)
    wall.super.init(self, theWorld, startPosition)
    self.char = "M"
    self.name = "Wall"
    self.description = "A cold wall."
end

function wall:update()
    wall.super.update(self)
end