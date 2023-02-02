class("Animal").extends(Actor)

function Animal:init(theLevel, startPosition)
    Animal.super.init(self, theLevel, startPosition)
    self.name = "Animal"
    self.description = "A cute cuddly animal."
end

function Animal:tick()
    Animal.super.tick(self)
    self:move(Vector2.new(math.random(-1,1), math.random(-1,1)))
end

function Animal:interact(Actor)
    if (Actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:add(self.description)
    end
end