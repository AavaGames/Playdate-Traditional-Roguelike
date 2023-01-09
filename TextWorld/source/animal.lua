class("animal").extends(actor)

function animal:init(theWorld, x, y)
    animal.super.init(self, theWorld, x, y)
    self.name = "Animal"
end

function animal:update()
    animal.super.update(self)
    self:move(math.random(-1,1), math.random(-1,1))
end