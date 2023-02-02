class("feature").extends(entity)

function feature:init(theWorld, startPosition)
    self.char = "F"
    self.name = "Feature"
    self.description = "A feature of the world."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function feature:interact(actor)
    -- abstract func for children
end

function feature:getChar()
    return self.char
end