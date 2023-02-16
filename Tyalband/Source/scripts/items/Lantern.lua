class("Lantern").extends(Light)

function Lantern:init(actor)
    Lantern.super.init(self, actor)
    self.name = "Lantern"
    self.quality = self.QualityTypes.Average
end