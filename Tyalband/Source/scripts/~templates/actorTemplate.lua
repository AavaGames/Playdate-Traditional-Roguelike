class("A").extends(Actor)

function A:init(theWorld, startPosition)
    A.super.init(self, theWorld, startPosition)
    self.char = "#"
    self.name = "Wall"
    self.description = "A cold wall."
end

function A:tick()
    A.super.tick(self)
end