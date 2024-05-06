---@class Zombie : Monster
---@overload fun(theLevel: Level, startPosition: Vector2): Zombie
Zombie = class("Zombie").extends("Monster") or Zombie


function Zombie:init(theLevel, startPosition)
    Zombie.super.init(self, theLevel, startPosition)
    self.name = "Zombie"
    self.glyph = "z"
    self.description = "A walking corpse."

    self.moveSpeed = 2
    self.visionRange = 3

    self.health:setMaxHP(7)
end