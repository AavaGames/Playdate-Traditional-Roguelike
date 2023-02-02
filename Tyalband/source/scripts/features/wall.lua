class("wall").extends(feature)

function wall:init(theWorld, startPosition)
    wall.super.init(self, theWorld, startPosition)
    self.char = "#"
    self.name = "Crystal"
    self.description = "A cold perfectly transparent crystal."
    
    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function wall:interact(actor)
    if (actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:add(self.description)
    end
end