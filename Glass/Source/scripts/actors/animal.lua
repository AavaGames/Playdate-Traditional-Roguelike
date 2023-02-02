class("animal").extends(actor)

function animal:init(theWorld, startPosition)
    animal.super.init(self, theWorld, startPosition)
    self.name = "Animal"
    self.description = "A cute cuddly animal."
end

function animal:tick()
    animal.super.tick(self)
    self:move(Vector2.new(math.random(-1,1), math.random(-1,1)))
end

function animal:interact(actor)
    if (actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:add(self.description)
    end
end