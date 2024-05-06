---@class Glass : Feature
---@overload fun(theLevel: Level, startPosition: Vector2): Glass
Glass = class("Glass").extends("Feature") or Glass

function Glass:init(theLevel, startPosition)
    Glass.super.init(self, theLevel, startPosition)
    self.glyph = "%"
    self.name = "Glass"
    self.description = "A thin piece of glass. Destructable."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end