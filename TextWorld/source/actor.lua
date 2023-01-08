import "global"
import "entity"
import "world"

class("actor").extends(entity)

ACTIVE = 0
INACTIVE = 1

function actor:init(theWorld, x, y)
    self.char = "a"
    self.name = "Actor"
    self.description = "An actor"
    
    self.x = 0
    self.y = 0
    self.updated = false
    self.state = ACTIVE

    self.world = theWorld
    self.tile = nil
    self:move(x, y) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
end

function actor:update()
    self.updated = true
end

function actor:move(x, y)
    x += self.x
    y += self.y
    if x ~= self.x or y ~= self.y then
        if self.world:setLocation(self, x, y) then
            self.x = x
            self.y = y
        else
            --print(self.name .. " collided")
        end
    end
end

function actor:updateTile(tile)
    if self.tile ~= nil then
        self.tile:exit(self)
    end
    self.tile = tile 
    self.tile:enter(self)
end