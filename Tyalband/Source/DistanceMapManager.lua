local gfx <const> = playdate.graphics

local distanceMapMaxLimit <const> = 100

class("DistanceMapManager").extends()

function DistanceMapManager:init(level, gridDimensions)

    --[[
        Holds maps, checks whether they were updated already this round
            Checks if its necessary to update (sources have changed)

    ]]

    self.toPlayerPathMap = DistanceMap.new(gridDimensions.x, gridDimensions.y)
    self.toPlayerPathMapSources = {}
	--self.toPlayerPathMap:addSource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    self.smellMap = { 
        map = DistanceMap.new(self.gridDimensions.x, self.gridDimensions.y),
        centerSource = nil,
        sources = {},
        updated = false
    }
	--self.smellMap:addPrimarySource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    self.soundMap = DistanceMap.new(self.gridDimensions.x, self.gridDimensions.y)
	--self.soundMap:addSource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    -- Contains { map = C.DistanceMap, source = {}, updated = false }
    self.distanceMaps = {}

end

function DistanceMapManager:getMap(map)
    if (type(map) == "string") then
        return self.distanceMap[map]
    elseif (map ~= nil) then
        return map
    else
        print("DistanceMapManager ERROR: map recieved is nil", map)
    end
end

-- Returns direction to move towards nearest goal
function DistanceMapManager:getStep(map, position)
    local map = self:getMap(map)
    -- get CameFrom vector
end

-- Returns a table of directions to reach the nearest goal
function DistanceMapManager:getPath(map) end 

function DistanceMapManager:updateMap(map)
    -- if nil make map, where are sources?

    -- if map has changed then update
    -- return 

end

function DistanceMapManager:debugDrawMap(map)

end

function DistanceMapManager:addCenterSource(map, actor, weight)
    local map = self:getMap(map)
    map.centerSource = DistanceMapSource(actor, weight)
end

function DistanceMapManager:addSource(map, actor, weight)
    local map = self:getMap(map)
    table.insert(map.sources, DistanceMapSource(actor, weight))
end

function DistanceMapManager:setRangeLimit(map, limit)
    local map = self:getMap(map)
    -- set limit
end

--#region DistanceMapSource

class("DistanceMapSource").extends()

function DistanceMapSource:init(actor, weight)
    self.actor = actor
    self.lastActorPosition = nil
    self.weight = weight
end

function DistanceMapSource:hasChanged()
    if (self.actor.position ~= self.lastActorPosition) then
        self.lastActorPosition = Vector2.copy(self.actor.position)
        return true
    end
    return false
end