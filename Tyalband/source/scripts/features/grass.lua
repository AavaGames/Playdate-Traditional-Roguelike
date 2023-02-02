class("Grass").extends(Feature)

function Grass:init()
    Grass.super:init(self)
    self.char = "v"
    self.name = "Grass"
    self.description = "Grass swaying in the wind"

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end