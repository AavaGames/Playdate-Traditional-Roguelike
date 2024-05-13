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

    utilities.seedUsingTime(999999)
    math.randomseed(895960)

    self.gridDimensions = { x = 50, y = 20 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)
    end


    local roomAmountRange = Vector2.new(8, 12)
    local roomWidthRange = Vector2.new(5, 9)
    local roomHeightRange = Vector2.new(5, 7)
    local maxRoomPlacingAttempts = 5

    local randomTunnelTurnChance = 0

    local roomAmount = math.random(roomAmountRange.x, roomAmountRange.y)

    local rooms = table.create(roomAmount)

    -- optimizations
    -- Add walls when making rooms, walls are placed when x and y are 1 or max
        -- what about tunnels?
    -- tunneler will have to break the first wall, then it will stop when it encounters not nil
        -- tunneler should only connect to closest room and make sure it reaches that room before stopping

    local function addRooms()
        -- create a simple dungeon algorithm, place rectangles and then connect them all with tunnels

        for i = 1, roomAmount, 1 do
            local roomWidth = math.random(roomWidthRange.x, roomWidthRange.y)
            local roomHeight = math.random(roomHeightRange.x, roomHeightRange.y)

            local room = { w = roomWidth, h = roomHeight, size = roomWidth * roomHeight, position = nil }
            table.insert(rooms, room)
        end

        -- sort rooms by size
        table.sort(rooms, function(a, b) return a.size > b.size end)

        -- place rooms
        for i, room in ipairs(rooms) do
            local position = Vector2.one()

            -- check if intersecting with other rooms X times
            local attempts = 1
            repeat
                -- add padding to edge to be able to place walls
                position.x = math.random(2, self.gridDimensions.x - room.w - 1)
                position.y = math.random(2, self.gridDimensions.y - room.h - 1)
                if (not self:boundingBoxTileCheck(position, room.w, room.h)) then
                    pDebug:log("Room not colliding " .. i .. " attempts: " .. attempts)
                    break
                end
                attempts += 1
            until attempts > maxRoomPlacingAttempts

            if (attempts > maxRoomPlacingAttempts) then
                pDebug:log("Nesting room " .. i)
            end

            room.position = position

            -- place room
            for xx = position.x, position.x + room.w, 1 do
                for yy = position.y, position.y + room.h, 1 do
                    -- place wall on edges
                    if (xx == position.x or xx == position.x + room.w
                        or yy == position.y or yy == position.y + room.h) then
                        self:addTile(xx, yy, Crystal)
                    else
                        self:addTile(xx, yy, Ground)
                    end
                end
            end
        end
    end

    local function addTunnels()
        for a = 1, #rooms - 1, 1 do
            for b = a + 1, #rooms, 1 do
                local roomA = rooms[a]
                local roomB = rooms[b]

                local centerA = Vector2.new(roomA.position.x + math.floor(roomA.w / 2),
                                            roomA.position.y + math.floor(roomA.h / 2))
                local centerB = Vector2.new(roomB.position.x + math.floor(roomB.w / 2),
                                            roomB.position.y + math.floor(roomB.h / 2))

                local tunneler

                local function tunnelStep()
                    -- move toward centerB
                    -- step without moving diagonal
                    -- sometimes switch axis of movement if moving in a straight line
                    
                    local d = centerB - tunneler

                    if (d.x == 0 and d.y == 0) then
                        return false
                    end

                    -- move toward centerB
                    if (math.abs(d.x) > math.abs(d.y)) then
                        if (d.x > 0) then
                            tunneler.x += 1
                        else
                            tunneler.x -= 1
                        end
                    else
                        if (d.y > 0) then
                            tunneler.y += 1
                        else
                            tunneler.y -= 1
                        end
                    end

                    -- -- 90 degree turn
                    -- if (math.random() < randomTunnelTurnChance) then
                    --     if (math.random() < 0.5) then
                    --         -- switch axis
                    --         local temp = tunneler.x
                    --         tunneler.x = tunneler.y
                    --         tunneler.y = temp
                    --     else
                    --         -- switch sign
                    --         tunneler.x = -tunneler.x
                    --         tunneler.y = -tunneler.y
                    --     end
                    -- end

                    return true
                end

                local function tunnelLoop(dryRun)

                    tunneler = centerA

                    local leftRoomA = false
                    while tunnelStep() do
                        local tile = self.grid[tunneler.x][tunneler.y]
    
                        if (tile == nil) then
                            if (not dryRun) then
                                self:addTile(tunneler.x, tunneler.y)
                            end
                        else
                            print(tunneler)

                            if (tile.feature.collision == true) then -- collided with a room wall
                                


                                if self:positionInBoundingBox(tunneler, roomA.position, roomA.w, roomA.h) then
                                    -- break wall of room A
                                    pDebug:log("breaking Room A wall")

                                    if (not dryRun) then
                                        tile.feature = Ground(self, Vector2.new(tunneler.x, tunneler.y))
                                    end
                                elseif self:positionInBoundingBox(tunneler, roomB.position, roomB.w, roomB.h) then

                                    pDebug:log("breaking Room B wall")

                                    -- break wall of room B 
                                    if (not dryRun) then
                                        tile.feature = Ground(self, Vector2.new(tunneler.x, tunneler.y))
                                    end
                                else
                                    

                                    print(roomA.position)
                                    printTable(roomA)
                                    print(roomB.position)
                                    printTable(roomB)

                                    -- hit wall of another room, tunnel is INVALID
                                    return false
    
                                end

                            elseif self:positionInBoundingBox(tunneler, roomA.position, roomA.w, roomA.h) == false then
                                -- found ground and out of room a
                                -- hit a tunnel or inside a room
                                pDebug:log("outer ground, stop")
                                break
                            else
                                pDebug:log("inner ground")
                                -- inner ground do nothing
                            end
                        end
                    end

                    return true
                end

                if (tunnelLoop(true)) then
                    tunnelLoop(false)
                else
                    pDebug:log("Invalid tunnel, skipping")
                end
            end
        end
    end

    local function addWalls()
        self:tileLoop(function (func, x, y)
            -- look at cardinal neighbors and if its null, place a tile and crystal there
            local tile = self.grid[x][y]

            if (tile.feature.collision == false) then

                -- place walls at any nil tile around ground (8 way)
                for i, pos in ipairs(tile:getNeighborPositions(true)) do

                    local neighbor = self.grid[pos.x][pos.y]
    
                    if (neighbor == nil) then
                        self:addTile(pos.x, pos.y, Crystal)
                    end

                end
                
            else

                -- remove walls if surrounded (4 way)
                local surrounded = true
                for i, pos in ipairs(tile:getNeighborPositions(true)) do
                    if (self:collisionCheck(pos)[1] == false) then
                        surrounded = false
                        break
                    end
                end
                if surrounded then
                    self.grid[x][y] = nil
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

    self.playerSpawnPosition = self:getRandomValidTilePosition()
    if (self.playerSpawnPosition == false) then
        self.playerSpawnPosition = Vector2.one()
    end

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