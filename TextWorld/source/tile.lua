import "global"
import "actor"


local gfx <const> = playdate.graphics

class("tile").extends()

function tile:init()
    self.decoration = nil
    self.actor = nil
    self.items = {}
    self.effects = {}
    self.triggers = {}
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

end

function tile:removeItem(item)

end