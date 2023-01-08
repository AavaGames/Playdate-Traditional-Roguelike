import "entity"

class("grass").extends(entity)

function grass:init()
    self.char = "v"
    self.name = "Grass"
    self.description = "Grass swaying in the wind"
end