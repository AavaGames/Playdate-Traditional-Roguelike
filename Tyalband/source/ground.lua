class("ground").extends(entity)

function ground:init()
    ground.super:init(self)
    self.char = "."
    self.name = "Ground"
    self.description = ""
end