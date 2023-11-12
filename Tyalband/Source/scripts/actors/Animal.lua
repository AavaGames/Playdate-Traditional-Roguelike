class("Animal").extends(Monster)

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