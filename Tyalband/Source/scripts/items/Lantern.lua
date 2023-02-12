class("Lantern").extends(Equipable)

function Lantern:init(actor)
    Lantern.super.init(self, actor)
    self.name = "Lantern"

    -- cant have components of components, how do i get this data right?
    self:addComponent(LightSource(2, 4))
end

function Lantern:pickup(actor)
    Lantern.super.pickup(self, actor)
end

function Lantern:drop(actor)
    Lantern.super.drop(self, actor)
end

function Lantern:inspect() end
function Lantern:use() end
function Lantern:throw() end