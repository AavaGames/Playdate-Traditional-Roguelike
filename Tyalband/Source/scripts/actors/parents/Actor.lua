---@class Actor
---@overload fun(theLevel: Level, startPosition: Vector2): Actor
Actor = class("Actor").extends(Entity) or Actor


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

    -- tick speed of a turn
    self.TurnTicks = TurnTicks
    -- all action are cost multiple (0.5) of this value
    self.baseActionTicks = self.TurnTicks

    self.ticksTillAction = self.TurnTicks

    -- the multiple cost of moving (0.5 slow, 1.0 normal, 2.0 haste)
    self.moveSpeed = 1.0
    -- the speed at which actors attack (0.5 very fast, 1.0 normal, 2 slow)
    -- brogue based attack speed not angband
    self.attackSpeed = 1.0

    -- Status Effects
    self.timedEffects = {}
    self.permaEffects = {}

    self.currentTarget = nil

    -- Components

    self.health = self:addComponent(Health())
    self.health.onDeath = function() self:death() end

    --

    if (theLevel ~= nil and startPosition ~= nil) then
        self.level:spawnAt(startPosition, self)
        self.state = self.States.Active
    end
end

function Actor:round(ticks)
    self.ticksTillAction -= ticks -- decrease by player action ticks
    while self.ticksTillAction <= 0 do
        self:doAction() -- take actions until needing to wait again
    end
end

--#region Abstract functions

function Actor:doAction() end -- Actor finds and does an action. Actions must increment self.ticksTillAction
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

function Actor:getTicks(speed)
    --if (speed == 1) then return self.baseActionTicks end
    return math.round(self.baseActionTicks * speed)
end

--#region General Actions

-- Movement action
function Actor:move(moveAmount)
    local newPosition = self.position + Vector2.new(moveAmount.x, moveAmount.y)
    local moved = self:moveTo(newPosition)
    if (moved) then
        self.ticksTillAction += self:getTicks(self.moveSpeed)
    else
        -- couldn't move, wait instead?
    end
    return moved
end

function Actor:wait()
    self.ticksTillAction += self:getTicks(self.moveSpeed)
end

function Actor:attack()
    -- attack currentTarget
    self.ticksTillAction += self:getTicks(self.attackSpeed)
end

--#endregion