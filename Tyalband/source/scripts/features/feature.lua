class("Feature").extends(Entity)

function Feature:init(theWorld, startPosition)
    self.char = "F"
    self.name = "Feature"
    self.description = "A feature of the world."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function Feature:interact(actor)
    -- abstract func for children
end

function Feature:getChar()
    return self.char
end