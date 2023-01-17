class("a").extends(actor)

function a:init(theWorld, startPosition)
    a.super.init(self, theWorld, startPosition)
    self.char = "#"
    self.name = "Wall"
    self.description = "A cold wall."
end

function a:update()
    a.super.update(self)
end