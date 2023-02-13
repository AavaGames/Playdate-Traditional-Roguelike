class("Item").extends(Entity)

local ItemType <const> = enum.new({
    "Equipable",
    "Consumable",
    "Money"
})

function Item:init(actor)
    Item.super.init(self)
    self.name = "Item" -- randomized name based on type
    self.glyph = "="
    self.description = "An item."

    self.ItemType = ItemType
    self.type = nil

    self.heldBy = actor or nil -- actor
end

function Item:pickup(actor)
    isObjectError(actor, Actor)
    self.heldBy = actor
    if (not self.heldBy:hasComponent(Inventory)) then
        self.heldBy:addComponent(Inventory())
    end
    return self.heldBy:getComponent(Inventory):addItem(self)
end

-- Removes the item from the inventory
function Item:remove(actor)
    if (not self.heldBy) then self.heldBy = actor end
    if (actor:hasComponent(Inventory)) then
        actor:getComponent(Inventory):removeItem(self)
    else
        pDebug.error("Cannot remove " .. self.name .. " item from actor ", actor.name)
    end
end

-- Drops the item to the floor
function Item:drop(actor, amount) -- TODO add amount, and drop to the floor
    self.heldBy:getComponent(Inventory):dropItem(self, amount)
    self.heldBy = nil
end

function Item:hit(damageStats) end
function Item:destroy() end

function Item:inspect() end
function Item:use() end
function Item:throw() end