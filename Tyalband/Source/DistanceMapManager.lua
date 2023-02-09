local gfx <const> = playdate.graphics

local distanceMapMaxLimit <const> = 100

class("DistanceMapManager").extends()

function DistanceMapManager:init(level, gridDimensions)
    self.level = level
    self.gridDimensions = gridDimensions
    -- map: toPlayerPathMap, smellMap, soundMap

    -- Contains { cMap = C.DistanceMap, source = {}, updated = false }
    self.distanceMaps = {}

end

function DistanceMapManager:reset()
    for key, map in pairs(self.distanceMaps) do
        map.updated = false
    end
    print("maps reset")
end

function DistanceMapManager:addMap(name, centerSourceActor, centreSourceWeight, rangeLimit)
    self.distanceMaps[name] = {
        cMap = DistanceMap.new(self.gridDimensions.x, self.gridDimensions.y, rangeLimit or distanceMapMaxLimit),
        centerSource = centerSourceActor and DistanceMapSource(centerSourceActor, centreSourceWeight) or nil,
        sources = {},
        updated = centerSourceActor == nil
    }
end

function DistanceMapManager:getMap(map)
    if (type(map) == "string") then
        if (self.distanceMaps[map] ~= nil) then
            return self.distanceMaps[map]
        else
            print("DistanceMapManager ERROR: map recieved is nil", map)
        end
    elseif (map ~= nil) then
        return map
    else
        print("DistanceMapManager ERROR: map recieved is nil", map)
    end
end

-- Returns direction to move towards nearest goal
function DistanceMapManager:getStep(map, position)
    local map = self:getMap(map)
    self.checkForUpdate(map)
    -- get CameFrom vector
end

function DistanceMapManager:getTile(map, x, y)
    local map = self:getMap(map)
    self:checkForUpdate(map)
    return map.cMap:getTile(x, y)
end

-- Returns a table of directions to reach the nearest goal
function DistanceMapManager:getPath(map) end

function DistanceMapManager:checkForUpdate(map)
    local map = self:getMap(map)
    if (map.updated == false) then
        local needsUpdate = map.centerSource:hasChanged()
        if (needsUpdate == false) then
            for i = 1, #map.sources, 1 do
                if (map.sources[i]:hasChanged()) then
                    needsUpdate = true
                    break
                end
            end
        end
        if (needsUpdate == true) then
            frameProfiler:startTimer("Pathfinding: update map")
            self:updateMap(map)
            frameProfiler:endTimer("Pathfinding: update map")
        end
    end
    map.updated = true
end

function DistanceMapManager:updateMap(map)
    print("updated map")
    local map = self:getMap(map)
    map.cMap:clearSources()
    if (map.centerSource) then
        map.cMap:addCenterSource(map.centerSource.actor.position.x, map.centerSource.actor.position.y, map.centerSource.weight)
    end
    if (#map.sources > 0) then
        for i = 1, #map.sources, 1 do
            local source = map.sources[i]
            map.cMap:addSource(source.actor.position.x, source.actor.position.y, source.weight)
        end
    end
    map.cMap:fillMap()
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
    map.cMap:setRangeLimit(limit)
end

function DistanceMapManager:debugDrawMap(map, camera)
    local map = self:getMap(map)
    local screenManager = screenManager
    local viewport = screenManager.viewport
    local fontSize = screenManager.currentLevelFont.size

    -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed
    local startTileX = camera.position.x - math.floor(screenManager.viewportCharDrawMax.x*0.5)
    local startTileY = camera.position.y - math.floor(screenManager.viewportCharDrawMax.y*0.5)

    local xOffset = 0
    local yOffset = 0

    local tile = Tile()
    tile.lightLevel = 2

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(screenManager.currentLevelFont.font)

    for xPos = 0, screenManager.viewportCharDrawMax.x - 1, 1 do
        for yPos = 0, screenManager.viewportCharDrawMax.y - 1, 1 do

            local x = startTileX + xOffset
            local y = startTileY + yOffset

            local drawCoord = { 
                x = viewport.x + fontSize.width * xPos,
                y = viewport.y + fontSize.height * yPos
            }

            local char = ""
            -- once > 9 then draw in ascii ranges of 64-89 & 96-121 -- string.char(i + 64)
            local step = self:getTile(map, x, y)
            if (step ~= nil) then
                
                if (step < 0) then
                    tile.lightLevel = 0
                else
                    tile.lightLevel = 2
                end
                step = math.abs(step)
                if (step < 10) then
                    char = step
                else
                    -- map to range?
                    if (step < 126) then
                        char = string.char(step - 9 + 64)

                    end
                end 
            end

            screenManager:drawGlyph(char, tile, drawCoord, {
                x = xPos,
                y = yPos
            })
            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end
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
        print("source changed")
        self.lastActorPosition = Vector2.copy(self.actor.position)
        return true
    else
        print("no change")
    end
    return false
end