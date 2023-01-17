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

    self.collision = true
    self.renderWhenSeen = false
    self.blockVision = false

    if (theWorld ~= nil and startPosition ~= nil) then
        self:moveTo(startPosition) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = ACTIVE
    end
end

function actor:update()
    self.updated = true
end

function actor:interact()
    -- abstract func for children
end

function actor:move(moveAmount)
    local newPosition = self.position + Vector2.new(moveAmount.x, moveAmount.y)
    return self:moveTo(newPosition)
end

function actor:moveTo(position)
    -- check if position is a vector ?
    if position.x ~= self.position.x or position.y ~= self.position.y then
        local collision = self.world:collisionCheck(position)
        if collision[1] == false then
            self:updateTile(collision[2])
            return true
        elseif collision[2] ~= false then
            collision[2]:interact(self) -- interact with actor
        end
    end
    return false
end

-- called?
function actor:updateTile(tile)
    if self.tile ~= nil then
        self.tile:exit(self)
    end
    self.tile = tile 
    self.position = self.tile.position
    self.tile:enter(self)
end

function actor:getChar()
    return self.char
end