class("animal").extends(actor)

function animal:init(theWorld, startPosition)
    animal.super.init(self, theWorld, startPosition)
    self.name = "Animal"
end

function animal:update()
    animal.super.update(self)
    self:move(Vector2.new(math.random(-1,1), math.random(-1,1)))
end