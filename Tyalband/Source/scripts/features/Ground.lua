---@class Ground
---@overload fun(theLevel: Level, startPosition: Vector2): Ground
Ground = class("Ground").extends(Feature) or Ground

function Ground:init()
    Ground.super:init(self)
    self.glyph = "."
    self.name = "Ground"
    self.description = ""

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end