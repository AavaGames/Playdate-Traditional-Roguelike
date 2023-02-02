class("A").extends(Actor)

function A:init(theLevel, startPosition)
    A.super.init(self, theLevel, startPosition)
    self.char = "#"
    self.name = "Wall"
    self.description = "A cold wall."
end

function A:tick()
    A.super.tick(self)
end