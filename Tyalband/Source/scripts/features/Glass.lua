class("Crystal").extends(Feature)

function Crystal:init(theLevel, startPosition)
    Crystal.super.init(self, theLevel, startPosition)
    self.glyph = "%"
    self.name = "Glass"
    self.description = "A thin piece of crystal. Destructable."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
ends