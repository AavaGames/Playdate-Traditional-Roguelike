class("Glass").extends(Feature)

function Glass:init(theLevel, startPosition)
    Glass.super.init(self, theLevel, startPosition)
    self.glyph = "%"
    self.name = "Glass"
    self.description = "A thin piece of crystal. Destructable."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end