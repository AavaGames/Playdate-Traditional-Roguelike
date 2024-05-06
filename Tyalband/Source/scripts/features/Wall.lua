---@class Wall
---@overload fun(theLevel: Level, startPosition: Vector2): Wall
Wall = class("Wall").extends(Feature) or Wall

function Wall:init(theLevel, startPosition)
    Wall.super.init(self, theLevel, startPosition)
    self.glyph = "#"
    self.name = "Wall"
    self.description = "A cold stone wall."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end