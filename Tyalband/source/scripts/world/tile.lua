local gfx <const> = playdate.graphics

class("tile").extends()

function tile:init(x, y)
    self.position = Vector2.new(x, y)
    self.decoration = ground()
    self.actor = nil
    self.item = nil
    self.effects = {}
    self.triggers = {}

    self.seen = false
    self.visibilityState = { unknown = 0, lit = 1, dim = 2, seen = 3 }
    self.currentVisibilityState = unknown

    self.blocksLight = false
end

function tile:update()
    for i, trigger in ipairs(triggers) do
        if trigger ~= null then
            trigger:update()
        end
    end
end

function tile:enter(actor)
    self.actor = actor
end

function tile:exit(actor)

    self.actor = nil
end

function tile:addItem(item)
    -- if have item, move to another tile
end

function tile:removeItem(item)

end