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

    self.movespeed = 100

    -- Status Effects
    self.timedEffects = {}
    self.permaEffects = {}

    if (theLevel ~= nil and startPosition ~= nil) then
        self.level:spawnAt(startPosition, self) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = self.states.Active
    end
end

-- Abstract funcs
function Actor:round() end
function Actor:interact() end

function Actor:move(moveAmount)
    local newPosition = self.position + Vector2.new(moveAmount.x, moveAmount.y)
    return self:moveTo(newPosition)
end

-- Takes a Vector2 and attemps to move to that tile on the level
function Actor:moveTo(position)
    if (not Vector2.isa(position)) then pDebug.error(position, "is not a Vector2") end -- sanity check
    if position ~= self.position then
        local collision = self.level:collisionCheck(position)
        if collision[1] == false then
            self:updateTile(collision[2]) -- move to free tile
            return true
        elseif collision[2] ~= nil then
            collision[2]:interact(self) -- interact with actor or feature
        end
    end
    return false
end

function Actor:updateTile(tile)
    if self.tile ~= nil then
        self.tile:exit(self)
    end
    self.tile = tile 
    self.position = Vector2.copy(self.tile.position)
    self.tile:enter(self)
end

function Actor:getGlyph()
    return self.glyph
end