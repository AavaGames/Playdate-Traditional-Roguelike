class("Feature").extends(Entity)

function Feature:init(theLevel, startPosition)
    self.glyph = "F"
    self.name = "Feature"
    self.description = "A feature of the level."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function Feature:getGlyph()
    return self.glyph
end

function Feature:logDescription()
    gameManager.logManager:addToRound(self.description)
end