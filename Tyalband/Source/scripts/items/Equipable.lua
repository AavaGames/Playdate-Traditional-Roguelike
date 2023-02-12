class("Equipable").extends(Item)

function Equipable:init(actor)
    Equipable.super.init(self, actor)

    -- Equipable type enum
end

function Equipable:pickup(actor)
    Equipable.super.pickup(self, actor)
end

function Equipable:drop(actor)
    Equipable.super.drop(self, actor)
end

function Equipable:inspect() end
function Equipable:use() end
function Equipable:throw() end

function Equipable:equip()

end

function Equipable:unequip()

end
