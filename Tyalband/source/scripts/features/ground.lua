class("Ground").extends(Feature)

function Ground:init()
    Ground.super:init(self)
    self.char = "."
    self.name = "Ground"
    self.description = ""

    self.collision = false
    self.renderWhenSeen = true

    self.moveCost = 1
end