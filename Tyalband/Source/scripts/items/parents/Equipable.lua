class("Equipable").extends(Item)

local QualityTypes <const> = enum.new({
    "Average",
    "Good",
    "Powerful",
    "Artifact"
})

local EquipType <const> = enum.new({
    "Weapon",
    "OffHand",
    "Head",
    "Arms",
    "Chest",
    "Legs",
    "Feet",
    "Neck",
    "Ring",
    "Light"
})

function Equipable:init(actor)
    Equipable.super.init(self, actor)

    self.EquipType = EquipType
    self.QualityTypes = QualityTypes

    self.equipType = nil
    self.quality = nil

    self.cursed = false
end

-- Equips the item to the actors equipment
function Equipable:equip(actor)
    if (not self.heldBy) then -- bypasses pickup to inventory
        self.heldBy = actor
    else -- remove from inventory
        self.heldBy:getComponent(Inventory):removeItem(self)
    end 

    if (not self.heldBy:hasComponent(Equipment)) then
        self.heldBy:addComponent(Equipment())
    end
    self.heldBy:getComponent(Equipment):equip(self)
end

-- called by Equipment when removed
function Equipable:unequip()
    -- TODO add to inventory or drop to ground
    self:pickup(self.heldBy)
end

-- Super Functions

function Equipable:pickup(actor)
    Equipable.super.pickup(self, actor)
end

function Equipable:remove(actor)
    Equipable.super.remove(self, actor)
end

function Equipable:drop(actor)
    Equipable.super.drop(self, actor)
end

function Equipable:inspect()
    Equipable.super.inspect(self)
end

function Equipable:use()
    Equipable.super.use(self)
end

function Equipable:throw()
    Equipable.super.throw(self)
end

function Equipable:hit(damageStats)
    Equipable.super.hit(self, damageStats)
end

function Equipable:destroy()
    Equipable.super.destroy(self)
end