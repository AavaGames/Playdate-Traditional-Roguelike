class("Actor").extends(Entity)

-- TODO move to enum
ACTIVE = 0
INACTIVE = 1

function Actor:init(theWorld, startPosition)
    self.char = "a"
    self.name = "Actor"
    self.description = "An actor."
    
    self.position = Vector2.zero()
    self.state = INACTIVE

    self.world = theWorld
    self.tile = nil -- to let it know its been exited

    self.renderWhenSeen = false

    if (theWorld ~= nil and startPosition ~= nil) then
        self.world:spawnAt(startPosition, self) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = ACTIVE
    end
end

function Actor:tick()

end

function Actor:interact()
    -- abstract func for children
end

function Actor:move(moveAmount)
    local newPosition = self.position + Vector2.new(moveAmount.x, moveAmount.y)
    return self:moveTo(newPosition)
end

function Actor:moveTo(position)
    -- check if position is a vector ?
    if position.x ~= self.position.x or position.y ~= self.position.y then
        local collision = self.world:collisionCheck(position)
        if collision[1] == false then
            self:updateTile(collision[2])
            return true
        elseif collision[2] ~= nil then
            collision[2]:interact(self) -- interact with actor or feature
        end
    end
    return false
end

-- called?
function Actor:updateTile(tile)
    if self.tile ~= nil then
        self.tile:exit(self)
    end
    self.tile = tile 
    self.position = self.tile.position
    self.tile:enter(self)
end

function Actor:getChar()
    return self.char
end