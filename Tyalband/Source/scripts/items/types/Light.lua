---@class Light : Equipable
---@overload fun(actor: Actor): Light
Light = class("Light").extends("Equipable") or Light

function Light:init(actor)
    Light.super.init(self, actor)
    self.name = "Light"

    self.type = self.ItemType.Equipable
    self.equipType = eEquipType.Light
    self.quality = self.QualityTypes.Average

    self.source = self:addComponent(LightSource(2, 4))
end

function Light:equip(actor)
    Light.super.equip(self, actor)
    self:getComponent(LightSource):addToEmitter(self.heldBy)
end

function Light:unequip()
    self:getComponent(LightSource):removeFromEmitter(self.heldBy)
    Light.super.unequip(self)
end

function Light:getName()
    return self.name .. string.format(" {%d, %d}", self.source.brightRange, self.source.dimRange)
end

-- Super Functions

function Light:pickup(actor)
    Light.super.pickup(self, actor)
end

function Light:remove(actor)
    Light.super.remove(self, actor)
end

function Light:drop(actor)
    Light.super.drop(self, actor)
end

function Light:inspect()
    Light.super.inspect(self)
end

function Light:use()
    Light.super.use(self)
end

function Light:throw()
    Light.super.throw(self)
end

function Light:hit(damageStats)
    Light.super.hit(self, damageStats)
end

function Light:destroy()
    Light.super.destroy(self)
end