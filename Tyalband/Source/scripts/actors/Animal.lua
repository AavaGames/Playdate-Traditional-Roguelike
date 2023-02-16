class("Animal").extends(Monster)

function Animal:init(theLevel, startPosition)
    Animal.super.init(self, theLevel, startPosition)
    self.name = "Sabi"
    self.description = "A cute white cat tipped in black. It purrs loudly."
end

function Animal:round()
    Animal.super.round(self)
    self:move(Vector2.randomCardinal())
end

function Animal:interact(actor)
    if (actor:isa(Player)) then 
        gameManager.logManager:addToRound(self.description)
    end
end