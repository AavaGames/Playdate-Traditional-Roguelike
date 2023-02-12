class("Inventory").extends(Component)

function Inventory:init()
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
end

function Inventory:removeItem(item, amount)

end