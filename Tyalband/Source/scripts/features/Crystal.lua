class("Crystal").extends(Feature)

function Crystal:init(theLevel, startPosition)
    Crystal.super.init(self, theLevel, startPosition)
    self.char = "#"
    self.name = "Crystal"
    self.description = "A cold perfectly transparent crystal."
    
    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function Crystal:interact(actor)
    if (actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:addToRound(self.description)
    end
end