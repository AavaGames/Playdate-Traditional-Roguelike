class("a").extends(actor)

function a:init(theWorld, x, y)
    a.super.init(self, theWorld, x, y)
    self.char = "M"
    self.name = "Wall"
    self.description = "A cold wall."
end

function a:update()
    a.super.update(self)
end