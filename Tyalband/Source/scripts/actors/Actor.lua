class("Actor").extends(Entity)

local TurnTicks <const> = 100

local ActorStates <const> = enum.new({
    "Active",
    "self.States.Inactive"
})

function Actor:init(theLevel, startPosition)
    Actor.super.init(self)
    self.glyph = "a"
    self.name = "Actor"
    self.description = "An actor."

    self.position = Vector2.zero()
    self.States = ActorStates
    self.state = self.States.Inactive

    self.level = theLevel
    self.tile = nil -- to let it know its been exited

    self.visionRange = 4
    self.renderWhenSeen = false

    -- tick cost of a turn
    self.TurnTicks = TurnTicks
    -- all actions cost a multiple (0.5) of this value
    self.baseActionTicks = self.TurnTicks

    self.ticksTillNextAction = self.baseActionTicks

    -- the multiple cost of moving (0.5 slow, 1.0 normal, 2.0 haste)
    self.moveCost = 1.0

    -- Status Effects
    self.timedEffects = {}
    self.permaEffects = {}

    self.currentTarget = nil

    -- Components

    self.health = self:addComponent(Health())
    self.health.onDeath = function() self:death() end

    --

    if (theLevel ~= nil and startPosition ~= nil) then
        self.level:spawnAt(startPosition, self) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
        self.state = self.States.Active
    end
end

function Actor:round(ticks)
    self.ticksTillNextAction -= ticks -- decrease by player action ticks
    while self.ticksTillNextAction <= 0 do
        self:doAction() -- take actions until needing to wait again
    end
end

--#region Abstract functions

function Actor:doAction() end -- Actor finds and does an action. Actions must increment self.ticksTillNextAction
function Actor:interact() end -- interact with currentTarget, actor or feature

function Actor:death() end

--#endregion

-- Takes a Vector2 and attemps to move to that tile on the level
function Actor:moveTo(position)
    if (not Vector2.isa(position)) then pDebug.error(position, "is not a Vector2") end -- sanity check
    if position ~= self.position then
        local collision = self.level:collisionCheck(position)
        if collision[1] == false then
            self:updateTile(collision[2]) -- move to free tile
            return true
        elseif collision[2] ~= nil then
            self.currentTarget = collision[2]
            self:interact() -- interact with actor or feature
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

function Actor:getTicks(cost)
    --if (cost == 1) then return self.baseActionTicks end
    return math.round(self.baseActionTicks * cost)
end

--#region General Actions

-- Movement action
function Actor:move(moveAmount)
    local newPosition = self.position + Vector2.new(moveAmount.x, moveAmount.y)
    local moved = self:moveTo(newPosition)
    if (moved) then
        self.ticksTillNextAction += self:getTicks(self.moveCost)
    else
        -- couldn't move, wait instead?
    end
    return moved
end

function Actor:wait()
    self.ticksTillNextAction += self.TurnTicks --self.addTicks(self.moveCost)
end

function Actor:attack()
    -- attack currentTarget
    self.ticksTillNextAction += self.TurnTicks
end

--#endregion