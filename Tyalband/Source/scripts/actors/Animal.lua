class("Animal").extends(Monster)

function Animal:init(theLevel, startPosition)
    Animal.super.init(self, theLevel, startPosition)
    self.name = "Sabi"
    self.description = "A cute white cat tipped in black. It purrs loudly."

    self.moveSpeed = 1
end

function Animal:doAction()
    if self:move(Vector2.randomCardinal()) then
        return
    end

    self:wait()
end