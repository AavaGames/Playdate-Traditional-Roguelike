---@class Grass : Feature
---@overload fun(theLevel: Level, startPosition: Vector2): Grass
Grass = class("Grass").extends("Feature") or Grass

function Grass:init(theLevel, startPosition)
    Grass.super.init(self, theLevel, startPosition)
    self.glyph = "/"
    self.name = "Long Grass"
    self.description = "Long grass swaying in the wind."

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end