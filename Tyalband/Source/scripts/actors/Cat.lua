class("Cat").extends(Actor)

function Cat:init(theLevel, startPosition)
    Cat.super.init(self, theLevel, startPosition)
    self.name = "Cat"
    self.char = "c"
    self.description = "A cute white cat tipped in black. It purrs loudly."
end

function Cat:round()
    Cat.super.round(self)
    local move = math.random() <= 0.20
    if (move) then
        local dir = self.level.distanceMapManager:getStep("toPlayerPathMap", self.position)
        self:move(dir)
    end
end

function Cat:interact(Actor)
    if (Actor.name == "You") then
        gameManager.logManager:addToRound(self.description)
    end
end