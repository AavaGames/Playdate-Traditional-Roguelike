class("Equipment").extends(Component)

function Equipment:init()
    self.head = "Headpiece here"
    self.arms = nil
    self.chest = nil
    self.legs = nil
    self.feet = nil

    self.neck = nil
    self.leftRing = nil
    self.rightRing = nil

    self.light = nil
end

function Equipment:attach(entity)
    Equipment.super.attach(self, entity)
end

function Equipment:detatch(entity)
    Equipment.super.detatch(self, entity)
end

function Equipment:equip(item)
    -- is it an item
    -- what kind of item
    -- can it be equipped
    -- unequip prev then equip
end

function Equipment:unequip(item)

end