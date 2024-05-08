local gfx <const> = playdate.graphics

---@class Dungeon : Level
---@overload fun(theLevelManager: LevelManager, thePlayer: Player): Dungeon
Dungeon = class("Dungeon").extends("Level") or Dungeon

function Dungeon:init(theLevelManager, thePlayer)
    Dungeon.super.init(self, theLevelManager, thePlayer)

    -- do stuff
    self.name = "Dungeon Depth _"
    self.FullySeen = true
    
    Dungeon.super.finishInit(self)
end

-- Creates the dungeon, called in super.init
function Dungeon:create()
    -- abstract function to create grid. JSON or generated

    frameProfiler:startTimer("Dungeon Generation")

    self.gridDimensions = { x = 50, y = 20 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)
    end

    local seed = 343

    math.randomseed(seed)

    local roomAmount = 20
    local roomWidthRange = Vector2.new(3, 5)
    local roomHeightRange = Vector2.new(3, 5)

    local rooms = table.create(roomAmount)

    -- optimizations
    -- Add walls when making rooms, walls are placed when x and y are 1 or max
    -- tunneler will have to break the first wall, then it will stop when it encounters not nil

    local function addRooms()
        -- create a simple dungeon algorithm, place rectangles and then connect them all with tunnels

        for i = 1, roomAmount, 1 do
            local roomWidth = math.random(roomWidthRange.x, roomWidthRange.y)
            local roomHeight = math.random(roomHeightRange.x, roomHeightRange.y)

            -- add padding by 1 so walls can be placed
            local roomX = math.random(2, self.gridDimensions.x - roomWidth - 1)
            local roomY = math.random(2, self.gridDimensions.y - roomHeight - 1)

            local room = { x = roomX, y = roomY, w = roomWidth, h = roomHeight }
            table.insert(rooms, room)

            for x = roomX, roomX + roomWidth, 1 do
                for y = roomY, roomY + roomHeight, 1 do
                    self.grid[x][y] = Tile(self, x, y)
                end
            end
        end
    end

    local function addTunnels()
        -- tunnel between each room's center without diagonal movement
        for i = 1, #rooms - 1, 1 do
            local roomA = rooms[i]
            local roomB = rooms[i + 1]

            local pointA = Vector2.new(roomA.x + math.floor(roomA.w / 2), roomA.y + math.floor(roomA.h / 2))
            local pointB = Vector2.new(roomB.x + math.floor(roomB.w / 2), roomB.y + math.floor(roomB.h / 2))

            local x = pointA.x
            local y = pointA.y

            local startedTunneling = false

            while (x ~= pointB.x or y ~= pointB.y) do

                -- stop tunneling if we hit a tile only after we started tunneling
                -- since we start from the center of the room
                if (self.grid[x][y] ~= nil) then
                    if (startedTunneling) then
                        break
                    end
                else
                    startedTunneling = true
                    self.grid[x][y] = Tile(self, x, y)
                end

                if (x < pointB.x) then
                    x = x + 1
                elseif (x > pointB.x) then
                    x = x - 1
                else
                    if (y < pointB.y) then
                        y = y + 1
                    elseif (y > pointB.y) then
                        y = y - 1
                    end
                end

            end
        end
    end

    local function addWalls()
        self:tileLoop(function (func, x, y)
            -- look at cardinal neighbors and if its null, place a tile and crystal there
            local tile = self.grid[x][y]

            if (tile.feature.collision == false) then

                for i, pos in ipairs(tile:getNeighborPositions(true)) do

                    local neighbor = self.grid[pos.x][pos.y]
    
                    if (neighbor == nil) then
                        self.grid[pos.x][pos.y] = Tile(self, pos.x, pos.y, Crystal)
                    end

                end

            end

        end)
    end

    local function drawLoading(text)
        gfx.setFont(screenManager.menuFont)
        gfx.clear()
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextAligned(text .. "...", screenManager.screenDimensions.x, screenManager.screenDimensions.y - 16, kTextAlignment.right)
        coroutine.yield()
    end

    drawLoading("creating rooms")

    addRooms()

    drawLoading("creating tunnels")

    addTunnels()

    drawLoading("creating walls")

    addWalls()

    self.playerSpawnPosition = Vector2.new(rooms[1].x + math.floor(rooms[1].w / 2), rooms[1].y + math.floor(rooms[1].h / 2))

    self:print()

    frameProfiler:endTimer("Dungeon Generation")

    frameProfiler:startTimer("Dungeon Garbage Collection")

    --pDebug:log("garbage count = " .. collectgarbage("count"))

    drawLoading("collecting garbage")

    -- clean up
    collectgarbage("collect")

    frameProfiler:endTimer("Dungeon Garbage Collection")

    drawLoading("wrapping up")

end

