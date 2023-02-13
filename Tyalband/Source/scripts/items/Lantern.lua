class("Lantern").extends(Equipable)

function Lantern:init(actor)
    Lantern.super.init(self, actor)
    self.name = "Lantern"

    self:addComponent(LightSource(2, 4))
end

function Lantern:equip(actor)
    Lantern.super.equip(self, actor)
    self:getComponent(LightSource):addToEmitter(self.heldBy)
end

function Lantern:unequip()
    Lantern.super.unequip(self)
    self:getComponent(LightSource):removeFromEmitter(self.heldBy)
end

-- Super Functions

function Lantern:pickup(actor)
    Lantern.super.pickup(self, actor)
end

function Lantern:remove(actor)
    Lantern.super.remove(self, actor)
end

function Lantern:drop(actor)
    Lantern.super.drop(self, actor)
end

function Lantern:inspect()
    Lantern.super.inspect(self)
end

function Lantern:use()
    Lantern.super.use(self)
end

function Lantern:throw()
    Lantern.super.throw(self)
end

function Lantern:hit(damageStats)
    Lantern.super.hit(self, damageStats)
end

function Lantern:destroy()
    Lantern.super.destroy(self)
end