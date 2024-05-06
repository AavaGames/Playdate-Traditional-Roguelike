---@class Stairs
---@overload fun(theLevel: Level, startPosition: Vector2): Stairs
Stairs = class("Stairs").extends(Feature) or Stairs

function Stairs:init(theLevel, startPosition, goDown, levelClassToGoTo)
    Stairs.super.init(self, theLevel, startPosition)
    self.glyph = goDown and ">" or "<"
    self.name = "Stairs"
    self.description = goDown and "These stairs go down." and "These stairs go up."

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1

    self.levelClassToGoTo = levelClassToGoTo -- TODO change when floors exist
end

function Stairs:entered()
    gameManager.levelManager:loadLevel(self.levelClassToGoTo, true)
end