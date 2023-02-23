class("Crystal").extends(Feature)

function Crystal:init(theLevel, startPosition)
    Crystal.super.init(self, theLevel, startPosition)
    self.glyph = "#"
    self.name = "Crystal"
    self.description = "A cold perfectly transparent crystal."
    
    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end