class("Grass").extends(Feature)

function Grass:init()
    Grass.super:init(self)
    self.glyph = "/"
    self.name = "Long Grass"
    self.description = "Long grass swaying in the wind."

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end