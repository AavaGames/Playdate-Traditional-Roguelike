class("grass").extends(feature)

function grass:init()
    ground.super:init(self)
    self.char = "v"
    self.name = "Grass"
    self.description = "Grass swaying in the wind"

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end