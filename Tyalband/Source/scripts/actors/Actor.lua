class("Actor").extends(Entity)

local ActorStates <const> = enum.new({
    "Active",
    "self.states.Inactive"
})

function Actor:init(theLevel, startPosition)
    Actor.super.init(self)
    self.glyph = "a"
    self.name = "Actor"
    self.description = "An actor."

    self.position = Vector2.zero()
    self.states = ActorStates
    self.state = self.states.Inactive

    self.level = theLevel
    self.tile = nil -- to let it know its been exited

    self.visionRange = 4
    self.renderWhenSeen = false

    if (theLevel ~= nil and startPosition ~= nil) then
        self.level:spawnAt(startPosition, self) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = self.states.Active
    end
end

function Actor:round()

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
        local collision = self.level:collisionCheck(position)
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
    self.position = Vector2.copy(self.tile.position) -- pointer to a vector
    self.tile:enter(self)
end

function Actor:getGlyph()
    return self.glyph
end