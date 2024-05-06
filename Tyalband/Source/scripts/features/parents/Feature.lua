---@class Feature : Entity
---@overload fun(theLevel: Level, startPosition: Vector2): Feature
Feature = class("Feature").extends("Entity") or Feature

function Feature:init(theLevel, startPosition)
    self.glyph = "F"
    self.name = "Feature"
    self.description = "A feature of the level."

    self.collision = true
    self.renderWhenSeen = true

    self.level = theLevel
    self.position = startPosition -- Vector2

    self.moveCost = 1
end

function Feature:getGlyph()
    return self.glyph
end

function Feature:logDescription()
    gameManager.logManager:addToRound(self.description)
end