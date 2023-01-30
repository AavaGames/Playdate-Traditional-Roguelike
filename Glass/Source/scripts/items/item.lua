class("item").extends()

function item:init()
    self.name = "item" -- randomized name
    self.seen = false
end

function item:use() -- abstract func

end
