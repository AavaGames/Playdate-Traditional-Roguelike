class("Kobold").extends(Monster)

function Kobold:init(theLevel, startPosition)
    Kobold.super.init(self, theLevel, startPosition)
    self.name = "Kobold"
    self.glyph = "k"
    self.description = "A small dog like humanoid."

    self.moveSpeed = 1
    self.visionRange = 4

    self.health:setMaxHP(5)
end