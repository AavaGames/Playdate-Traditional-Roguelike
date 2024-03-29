class("Wall").extends(Feature)

function Wall:init(theLevel, startPosition)
    Wall.super.init(self, theLevel, startPosition)
    self.glyph = "#"
    self.name = "Wall"
    self.description = "A cold stone wall."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end