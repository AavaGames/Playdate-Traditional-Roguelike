class("A").extends(Actor)

function A:init(theLevel, startPosition)
    A.super.init(self, theLevel, startPosition)
    self.char = "#"
    self.name = "Actor"
    self.description = "A nice individual."
end

function A:round()
    A.super.round(self)
end