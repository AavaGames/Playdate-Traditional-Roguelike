class("actor").extends(entity)

ACTIVE = 0
INACTIVE = 1

function actor:init(theWorld, startPosition)
    self.char = "a"
    self.name = "Actor"
    self.description = "An actor"
    
    self.position = Vector2.zero()
    self.updated = false
    self.state = INACTIVE

    self.world = theWorld
    self.tile = nil
    if (theWorld ~= nil and startPosition ~= nil) then
        self:move(startPosition) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = ACTIVE
    end
end

function actor:update()
    self.updated = true
end

function actor:move(vector)
    vector += self.position
    if vector.x ~= self.position.x or vector.y ~= self.position.y then
        if self.world:setPosition(self, vector) then
            self.position = vector
            return true
        else
            --print(self.name .. " collided")
            return false
        end
    end
end

-- called?
function actor:updateTile(tile)
    if self.tile ~= nil then
        self.tile:exit(self)
    end
    self.tile = tile 
    self.tile:enter(self)
end