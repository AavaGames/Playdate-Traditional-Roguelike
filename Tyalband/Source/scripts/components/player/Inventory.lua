---@class Inventory
---@overload fun(): Inventory
Inventory = class("Inventory").extends(Component) or Inventory

function Inventory:init()
    Inventory.super.init(self)
    self.maxCapacity = 24
    self.items = table.create(self.maxCapacity)
    self.full = false
end

function Inventory:addItem(item)
    if (item.stackable) then
        for index, value in ipairs(self.items) do
            if (value.name == item.name) then
                value:addStack()
                return true -- stacked item
            end
        end
    end

    if (not self.full) then
        isObjectError(item, Item)
        if (item:isa(Item)) then
            pDebug:log("Added ", item:getName(), "item")
            table.insert(self.items, item)
            self.full = #self.items >= self.maxCapacity
            return true -- added to new slot
        else
            pDebug:log("Could not add item ", item)
        end
    end
    return false
end

-- Removes the item from the inventory
function Inventory:removeItem(item)
    if (item.stackable) then
        item:removeStack()
        if (item.stack <= 0) then
            item:remove()
        end
    else
        item:remove()
    end
end

-- Drops the item on the ground
function Inventory:dropItem(item)
 -- TODO drop to the floor
end