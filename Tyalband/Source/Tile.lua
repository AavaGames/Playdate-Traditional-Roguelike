local gfx <const> = playdate.graphics

---@class Tile : Object
---@overload fun(theLevel: Level, x: integer, y: integer, featureClass?: Feature): Tile
Tile = class("Tile").extends() or Tile

function Tile:init(theLevel, x, y, featureClass)
    self.level = theLevel

    self.position = Vector2.new(x, y)

    ---@type Feature
    self.feature = featureClass and featureClass(theLevel, Vector2.new(x, y)) or Ground(theLevel, Vector2.new(x,y))
    ---@type Actor
    self.actor = nil
    ---@type Item
    self.item = nil

    self.effects = {}
    self.triggers = {}

    self.seen = false
    self.visibilityState = { unknown = 0, lit = 1, dim = 2, seen = 3 }
    self.currentVisibilityState = self.visibilityState.unknown

    self.glow = false

    self.lightLevel = 0
    self.lightEmitters = {}
end

function Tile:update()
    for i, trigger in ipairs(triggers) do
        if trigger ~= nil then
            trigger:update()
        end
    end
end

function Tile:enter(actor)
    self.actor = actor
    -- TODO check setting and pickup item

    -- for traps and stairs, etc
    if (self.feature and self.feature.entered) then
        self.feature:entered()
    end
end

function Tile:exit(actor)
    -- on exit
    self.actor = nil
end

function Tile:addItem(item)
    -- if have item, move to another tile
end

function Tile:removeItem(item)
    self.item = nil
end

function Tile:resetLightLevel(baseLight)
    self.lightLevel = baseLight or 0
    self.lightEmitters = {}
end

function Tile:addLightLevel(level, emitter)
    if (self.lightEmitters[emitter] == nil) then
        self.lightEmitters[emitter] = emitter
        self.lightLevel += level
        -- TODO could optimize vis calls, if tile already had been called ignore (but what if the first check was dim and then lit)
        -- this shouldnt matter since light should always applies strongest first
    end
end

--#region Utility

---@param getIntercardinal? boolean @Optional, if true returns 8 neighbors, if false returns 4 neighbors
---@return table @Vector2[4] of neighbor positions [North, East, South, West, NE, SE, SW, NW]
function Tile:getNeighborPositions(getIntercardinal)
    local positions = table.create(getIntercardinal and 8 or 4)

    positions[1] = self.position + Vector2.up()
    positions[3] = self.position + Vector2.right()
    positions[2] = self.position + Vector2.down()
    positions[4] = self.position + Vector2.left()

    if (getIntercardinal) then
        positions[5] = self.position + Vector2.up() + Vector2.right()
        positions[6] = self.position + Vector2.down() + Vector2.right()
        positions[7] = self.position + Vector2.down() + Vector2.left()
        positions[8] = self.position + Vector2.up() + Vector2.left()
    end

    return positions

end

--#endregion