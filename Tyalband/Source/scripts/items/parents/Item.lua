class("Item").extends(Entity)

local ItemType <const> = enum.new({
    "Equipable",
    "Consumable",
    "Money"
})

-- Items are utilized by the player only
function Item:init(player)
    Item.super.init(self)
    self.name = "Item" -- randomized name based on type
    self.glyph = "="
    self.description = "An item."

    self.ItemType = ItemType
    self.type = nil

    self.heldBy = player or nil -- player

    self.stackable = true
    self.stack = 1
end

function Item:pickup(player)
    isObjectError(player, Player)
    self.heldBy = player
    if (not self.heldBy:hasComponent(Inventory)) then
        self.heldBy:addComponent(Inventory())
    end
    return self.heldBy:getComponent(Inventory):addItem(self)
end

-- Removes the item from the inventory
function Item:remove(player)
    if (not self.heldBy) then self.heldBy = player end
    if (player:hasComponent(Inventory)) then
        player:getComponent(Inventory):removeItem(self)
    else
        pDebug.error("Cannot remove " .. self.name .. " item from player")
    end
end

-- Drops the item to the floor
function Item:drop() -- TODO drop to the floor
    self.heldBy:getComponent(Inventory):dropItem(self)
    self.heldBy = nil
end

function Item:getName()
    local text = self.stack > 1 and self.stack .. "x " .. self.name or self.name
    return text
end

function Item:addStack(amount)
    self.stack += amount or 1
end

function Item:removeStack(amount)
    self.stack -= amount or 1
end

function Item:hit(damageStats) end
function Item:destroy() end

function Item:inspect() end
function Item:use() end
function Item:throw() end