class("Inventory").extends(Component)

function Inventory:init()
    Inventory.super.init(self)
    self.maxCapacity = 26
    self.items = table.create(self.maxCapacity)
end

function Inventory:attach(entity)
    Inventory.super.attach(self, entity)
end

function Inventory:detatch(entity)
    Inventory.super.detatch(self, entity)
end

function Inventory:addItem(item)
    -- check for stacks
    isObjectError(item, Item)

    if (item:isa(Item)) then
        pDebug.log("Added ", item.name)
        table.insert(self.items, item)
    else
        pDebug.error("Could not add item ", item)
        -- not an item
    end
end

-- Removes the item from the inventory
function Inventory:removeItem(item)

end

-- Drops the item on the ground
function Inventory:dropItem(item, amount)

end