class("Animal").extends(Actor)

function Animal:init(theLevel, startPosition)
    Animal.super.init(self, theLevel, startPosition)
    self.name = "Animal"
    self.description = "A cute cuddly animal."
end

function Animal:tick()
    Animal.super.tick(self)
    local move = Vector2.new(math.random(-1,1), math.random(-1,1))
    local dir = math.random(0, 1) == 0 and Vector2.right() or Vector2.up()
    move *= dir
    self:move(move)
end

function Animal:interact(Actor)
    if (Actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:addToRound(self.description)
    end
end