class("Equipment").extends(Component)

function Equipment:init()
    Equipment.super.init(self)

    -- TODO remake this into a normal array with index's
    self.slots = {
        weapon = nil, -- weapon
        offHand = nil, -- shield, staff or two handed weapon

        head = nil,
        arms = nil,
        chest = nil,
        legs = nil,
        feet = nil,

        neck = nil,
        leftRing = nil,
        rightRing = nil,

        light = nil
    }
    self.onEquipmentChange = function () end
end

function Equipment:equip(item)
    pDebug:log(item.name .. " equipped in slot " .. enum.getName(item.EquipType, item.equipType))
    if (item.equipType == item.EquipType.Weapon) then
        self:unequip(self.slots.weapon)
        self.slots.weapon = item
    elseif (item.equipType == item.EquipType.OffHand) then
        self:unequip(self.slots.offHand)
        self.slots.offHand = item
    elseif (item.equipType == item.EquipType.Head) then
        self:unequip(self.slots.head)
        self.slots.head = item
    elseif (item.equipType == item.EquipType.Arms) then
        self:unequip(self.slots.arms)
        self.slots.arms = item
    elseif (item.equipType == item.EquipType.Chest) then
        self:unequip(self.slots.chest)
        self.slots.chest = item
    elseif (item.equipType == item.EquipType.Legs) then
        self:unequip(self.slots.legs)
        self.slots.legs = item
    elseif (item.equipType == item.EquipType.Feet) then
        self:unequip(self.slots.feet)
        self.slots.feet = item
    elseif (item.equipType == item.EquipType.Neck) then
        self:unequip(self.slots.neck)
        self.slots.neck = item
    elseif (item.equipType == item.EquipType.Light) then
        self:unequip(self.slots.light)
        self.slots.light = item

    -- when choosing to equip a ring give option to equip in left or right hand
    elseif (item.equipType == item.EquipType.leftRing) then
        self:unequip(self.slots.leftRing)
        self.slots.leftRing = item
    elseif (item.equipType == item.EquipType.rightRing) then
        self:unequip(self.slots.rightRing)
        self.slots.rightRing = item

    else
        pDebug.error(item, "cannot be equipped")
    end
    self:onEquipmentChange()
end

function Equipment:replaceEquipment(item, slots)
    --slots:
end

function Equipment:unequip(item)
    -- if not nil then unequip and add to inventory or drop
    -- TODO rejig with an indexer
    if (item ~= nil) then
        print("unequipped " .. item.name)
        item:unequip()
        item = nil
        self:onEquipmentChange()
    end
end