class("Equipment").extends(Component)

eEquipmentSlots = enum.new({
    "Light", -- 1
    "Weapon",
    "Equipment",
    "Left Ring",
    "Right Ring", -- 5
})

function Equipment:init()
    Equipment.super.init(self)

    self.slots = table.create(#eEquipmentSlots)
    for key, value in pairs(eEquipmentSlots) do
        self.slots[value] = false
    end

    self.onEquipmentChange = function () end
end

-- Equips the item in its proper slot, replacing the slot if needed
-- @param ringSlot left ring = 0, right ring = 1
function Equipment:equip(item, ringSlot)
    local slot = item.equipType + (ringSlot or 0)
    self:unequip(slot, true)
    self.slots[slot] = item

    pDebug:log(item:getName() .. " equipped in slot " .. enum.getName(eEquipmentSlots, slot))

    self:onEquipmentChange()
end

function Equipment:unequip(slot, skipChangeCallback)
    if (self.slots[slot] ~= false) then
        pDebug:log("Unequipped " .. self.slots[slot]:getName())
        self.slots[slot]:unequip()
        self.slots[slot] = false
        if (not skipChangeCallback) then
            self:onEquipmentChange()
        end
    end
end