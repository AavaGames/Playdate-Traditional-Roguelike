---@class Item
---@overload fun(actor: Actor): Item
Item = class("Item").extends(Entity) or Item

local ItemType <const> = enum.new({
    "Equipable",
    "Consumable",
    "Currency",
})

function Item:init(actor)
    Item.super.init(self)
    self.name = "Item" -- randomized name based on type
    self.glyph = "=" -- glyph changes depending on item type and subtype
    self.description = "An item."

    self.ItemType = ItemType
    self.type = nil

    self.heldBy = actor or nil

    self.stackable = true
    self.stack = 1
end

function Item:pickup(actor)
    isObjectError(actor, Actor)
    self.heldBy = actor
    if (not self.heldBy:hasComponent(Inventory)) then
        self.heldBy:addComponent(Inventory())
        return self.heldBy:getComponent(Inventory):addItem(self)
    else
        pDebug:log("Cannot add item " .. self.name .. " to " .. actor.name .. " as it does not have an inventory.")
    end
end

-- Removes the item from the inventory
function Item:remove()
    if (self.heldBy == nil) then return end

    if (self.heldBy:hasComponent(Inventory)) then
        self.heldBy:getComponent(Inventory):removeItem(self)
    else
        pDebug:error("Cannot remove item " .. self.name .. " from " .. actor.name .. " as it does not have an inventory.")
    end
end

-- Drops the item to the floor
function Item:drop()
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