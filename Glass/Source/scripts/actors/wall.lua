class("wall").extends(actor)

function wall:init(theWorld, startPosition)
    wall.super.init(self, theWorld, startPosition)
    self.char = "#"
    self.name = "Wall"
    self.description = "A cold wall."
    self.renderWhenSeen = true
    self.blockVision = true
end

function wall:update()
    wall.super.update(self)
end

function wall:interact(actor)
    if (actor.name == "You") then --TODO think through interaction system
        gameManager.logManager:add(self.description)
    end
end