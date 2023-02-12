class("Item").extends(Entity)

function Item:init(actor)
    Item.super.init(self)
    self.name = "Item" -- randomized name based on type
    self.glyph = "="
    self.description = "An item."

    self.actor = actor or nil
end

function Item:pickup(actor)
    self.actor = actor
end

function Item:drop(actor)
    self.actor = nil
end

function Item:inspect() end
function Item:use() end
function Item:throw() end