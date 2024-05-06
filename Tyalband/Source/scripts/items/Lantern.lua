---@class Lantern
---@overload fun(actor: Actor): Lantern
Lantern = class("Lantern").extends(Light) or Lantern

function Lantern:init(actor)
    Lantern.super.init(self, actor)
    self.name = "Lantern"
    self.quality = self.QualityTypes.Average
end