class("Item").extends()

function Item:init()
    self.name = "item" -- randomized name
    self.seen = false
end

function Item:use() -- abstract func

end
