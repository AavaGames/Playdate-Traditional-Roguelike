class("Inventory").extends(Component)

function Inventory:init()
    Inventory.super.init(self)
    self.maxCapacity = 24
    self.items = table.create(self.maxCapacity)
    self.full = false
end

function Inventory:attach(entity)
    Inventory.super.attach(self, entity)
end

function Inventory:detatch(entity)
    Inventory.super.detatch(self, entity)
end

function Inventory:addItem(item)
    -- TODO check for stacks
    if (not self.full) then
        isObjectError(item, Item)
        if (item:isa(Item)) then
            pDebug.log("Added ", item.name)
            table.insert(self.items, item)
            self.full = #self.items >= self.maxCapacity
            return true
        else
            pDebug.log("Could not add item ", item)
        end
    end
    return false
end

-- Removes the item from the inventory
function Inventory:removeItem(item)

end

-- Drops the item on the ground
function Inventory:dropItem(item, amount)

end