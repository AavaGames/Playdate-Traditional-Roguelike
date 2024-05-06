---@class Animal
---@overload fun(theLevel: Level, startPosition: Vector2): Animal
Animal = class("Animal").extends(Monster) or Animal

function Animal:init(theLevel, startPosition)
    Animal.super.init(self, theLevel, startPosition)
    self.name = "Animal"
    self.description = "A cute fluffy mass. You can't help but want to pet it."

    self.moveSpeed = 1
    self.combatant = false
end

function Animal:doAction()
    if self:move(Vector2.randomCardinal()) then
        return
    end

    self:wait()
end