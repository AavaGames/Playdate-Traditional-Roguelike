local gfx <const> = playdate.graphics
local TurnTicks <const> = 100

---@class Level : Object
---@overload fun(theLevelManager :LevelManager, thePlayer :Player): Level
Level = class("Level").extends() or Level

function Level:init(theLevelManager, thePlayer)
    self.levelManager = theLevelManager
    self.player = thePlayer
    self.healthDisplay = HealthDisplay(self.player)

    self.name = "Level"
    self.playerSpawnPosition = Vector2.zero()

    self.FullyLit = false
    self.FullySeen = false

    self.grid = nil -- table
    self.gridDimensions = Vector2.zero()

    self.monsters = {}
    self.effects = {}

    self.visionTiles = nil

    self.distanceMapManager = nil

    self.debugDrawDistMap = false
    self.debugDistMap = "toPlayerPathMap"

    self.tickCounter = 0

    self:create()
end

function Level:finishInit()
    if (self.FullySeen == true) then
        self:tileLoop(function (tile)
            tile.seen = true
        end)
    end
    screenManager:setBGColor(self.FullyLit == true and gfx.kColorWhite or gfx.kColorBlack)

    if (self:collisionCheck(self.playerSpawnPosition)[1] == true) then
        pDebug:error("Player spawned inside collider")
        -- todo reconcile by finding a valid location to move
    end

    pDebug:log("Player Spawned at " .. tostring(self.playerSpawnPosition))

    self.player:spawn(self, self.playerSpawnPosition)
    self.camera = Camera(self.player)

    self.distanceMapManager = DistanceMapManager(self, self.gridDimensions)

    -- setup vision / light
    self:tileLoop(function (tile)
        if (tile.glow == true) then
            tile:resetLightLevel(2)
            tile.seen = true
        else
            tile:resetLightLevel()
        end

        if (self.FullyLit) then
            tile:addLightLevel(2, "Level")
            tile.seen = true
        end

        if (tile.seen == true) then
            tile.currentVisibilityState = tile.visibilityState.seen
        else
            tile.currentVisibilityState = tile.visibilityState.unknown
        end

        if (tile.feature.findWallGlyph ~= nil) then
            tile.feature:findWallGlyph()
        end
    end)

    if (not self.FullyLit) then
        self:updateLighting()
    end
end

-- Abstract function called by super init
function Level:create()
    -- abstract function to create grid
end

function Level:update() end
function Level:lateUpdate() end

-- Called by player on action taken
function Level:round()
    frameProfiler:startTimer("Logic: Monster Update")

    self.distanceMapManager:reset()

    local ticks = self.player.ticksTillAction
    self.tickCounter += ticks

    -- print("round tick = ", ticks)

    --if (self.tickCounter % TurnTicks * 10) then end -- 10 turns: regenerate player, poison
    --if (self.tickCounter % TurnTicks * 100) then end -- 100 turns: regenerate monsters

    -- TODO rework to check if monsters can take actions if other monsters have taken actions
    local monstersMax = #self.monsters
    for i = 1, monstersMax, 1 do
        local mon = self.monsters[i]
        if (not mon.dead) then
            mon:round(ticks);
        end
    end

    self.camera:update() -- must update last to follow player, if anything moved them

    frameProfiler:endTimer("Logic: Monster Update")

    self:updateLighting() -- TODO rework for multi lights

    screenManager:redrawLevel()
end

--region Drawing & Lighting
function Level:updateLighting()
    frameProfiler:startTimer("Logic: Vision")

    frameProfiler:startTimer("Vision: Reset")

    -- Only update if the light has moved

    -- optimize further by just resetting the tiles not seen anymore
    if (self.visionTiles ~= nil) then
        local max = #self.visionTiles
        for i = 1, max, 1 do
            local x, y = self.visionTiles[i][1], self.visionTiles[i][2]
            -- Reset previous lit tiles
            local tile = self:getTile(x, y)
            if (tile ~= nil) then
                if (tile.glow == true) then
                    tile:resetLightLevel(2)
                else
                    tile:resetLightLevel()
                end

                if (self.FullyLit) then
                    tile:addLightLevel(2, "Level")
                end

                if (tile.seen == true) then
                    tile.currentVisibilityState = tile.visibilityState.seen
                else
                    tile.currentVisibilityState = tile.visibilityState.unknown
                end
            end
        end
    end
    self.visionTiles = nil
    frameProfiler:endTimer("Vision: Reset")

    -- TODO keep track of emitters on the level and loop through, if onScreen + largestRange then calc
    if (self.player:hasComponent(LightEmitter)) then
        local emitterEntity = self.player
        local emitter = emitterEntity:getComponent(LightEmitter)

        frameProfiler:startTimer("Vision: Visible")
        self.visionTiles = math.findAllDiamondPos(emitterEntity.position.x, emitterEntity.position.y, emitter:largestRange())
        frameProfiler:endTimer("Vision: Visible")

        frameProfiler:startTimer("Vision: Apply Vis")
        local max = #self.visionTiles
        for i = 1, max, 1 do
            local x, y, distance = self.visionTiles[i][1], self.visionTiles[i][2], self.visionTiles[i][3]

            -- SetVisible
            local tile = self:getTile(x, y)
            if (tile ~= nil) then
                if (distance <= emitter.brightRange) then
                    tile.currentVisibilityState = tile.visibilityState.lit
                    tile:addLightLevel(2, emitter)
                    tile.seen = true
                elseif (distance <= emitter.dimRange) then
                    tile.currentVisibilityState = tile.visibilityState.dim
                    tile:addLightLevel(1, emitter)
                    tile.seen = true
                end
            end

        end
        frameProfiler:endTimer("Vision: Apply Vis")
    end

    frameProfiler:endTimer("Logic: Vision")
end

function Level:draw()
    self.healthDisplay:draw()

    if (self.debugDrawDistMap) then
        self.distanceMapManager:debugDrawMap(self.debugDistMap, self.camera)
        return
    end

    local screenManager = screenManager
    local viewport = screenManager.viewport
    local fontSize = screenManager.currentLevelFont.size

    -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed
    local startTileX = self.camera.position.x - math.floor(screenManager.viewportGlyphDrawMax.x*0.5)
    local startTileY = self.camera.position.y - math.floor(screenManager.viewportGlyphDrawMax.y*0.5)

    local xOffset = 0
    local yOffset = 0

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(screenManager.currentLevelFont.font)

    local drawPrint = table.create(screenManager.viewportGlyphDrawMax.x)

    -- TODO create a debug Draw Level to Console

    for xPos = 0, screenManager.viewportGlyphDrawMax.x - 1, 1 do
        drawPrint[xPos+1] = {}
        for yPos = 0, screenManager.viewportGlyphDrawMax.y - 1, 1 do

            local x = startTileX + xOffset
            local y = startTileY + yOffset

            local drawCoord = { 
                x = viewport.x + fontSize.width * xPos,
                y = viewport.y + fontSize.height * yPos
            }

            local glyph = ""
            local tile = self:getTile(x, y)
            if (tile ~= nil and tile.currentVisibilityState ~= tile.visibilityState.unknown) then
                if (tile.lightLevel > 0) then
                    if tile.actor ~= nil then
                        glyph = tile.actor:getGlyph()
                    elseif #tile.effects > 0 then
                        -- TODO add effects & drawing
                    elseif tile.item ~= nil then
                        glyph = tile.item:getGlyph()
                    elseif tile.feature ~= nil then
                        glyph = tile.feature:getGlyph()
                    end
                elseif tile.feature ~= nil then
                    glyph = tile.feature:getGlyph()
                end
            end
            screenManager:drawGlyph(glyph, tile, drawCoord, { 
                x = xPos,
                y = yPos
            })

            if (glyph == "") then
                glyph = " "
            end

            drawPrint[xPos+1][yPos+1] = glyph
            --gfx.setFont(screenManager.levelFont_8px.font)
            --gfx.drawText("X", drawCoord.x, drawCoord.y)

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end

    local drawToConsole = false
    if (drawToConsole == true) then
        local str = ""
        for y = 0, screenManager.viewportGlyphDrawMax.y - 1, 1 do
            for x = 0, screenManager.viewportGlyphDrawMax.x - 1, 1 do
                str = str .. drawPrint[x+1][y+1]
            end
            str = str .. "\n"
        end
        pDebug:log(str)
    end
end

--#endregion

function Level:spawnAt(position, monster)
    -- floodfill until a free position is found

    local validPos = self:floodFindValidPosition(position)
    if (validPos) then
        table.insert(self.monsters, monster)
        monster:moveTo(validPos)
        -- monsters flag for death to stop being updated and are they ever removed aside form level change?
    else
        pDebug:error("Could not find valid floodfilled position.")
    end

end

function Level:despawn(monster)
    --table.remove(self.monsters, monster.index)
end

--#region Utility

--- Prints the grid out in console
function Level:print()

    local table = ""

    for y = 1, self.gridDimensions.y, 1 do
        for x = 1, self.gridDimensions.x, 1 do

            if (self.playerSpawnPosition.x == x and self.playerSpawnPosition.y == y) then
                table = table .. "P"
                goto continue
            end


            local tile = self.grid[x][y]

            if (tile == nil) then
                table = table .. "_"
            else
                table = table .. "0"
            end
            ::continue::
        end
        table = table .. "\n"
    end

    printTable(table)

end

-- @param position Vector2
function Level:floodFindValidPosition(position)
    local validPos = position

    -- TODO optimize

    if (self:collisionCheck(validPos)[1] == true) then -- collision

        local toCheck = {}
        table.insert(toCheck, Vector2.unpack(validPos))

        while #toCheck >= 1 do

            local v = toCheck[1]
            local startPos = Vector2.new(v[1], v[2])

            for i = 1, 4, 1 do
                local pos = nil
                if (i == 1) then
                    pos = startPos + Vector2.up()
                elseif (i == 2) then
                    pos = startPos + Vector2.right()
                elseif (i == 3) then
                    pos = startPos + Vector2.down()
                elseif (i == 4) then
                    pos = startPos + Vector2.left()
                end

                local collision = self:collisionCheck(pos)
                if (collision[1] == false) then
                    --print("found spot")
                    validPos = pos
                    toCheck = {}
                    break
                elseif (collision[1] == true and collision[2] ~= nil) then
                    --print("adding new neighbor")
                    table.insert(toCheck, Vector2.unpack(pos))
                end
            end

            table.remove(toCheck, 1)
        end
    end

    return validPos
end

--- @param position Vector2
function Level:randomValidMoveDirection(position)

end

-- Returns the tile if it is in bounds and not nil
function Level:getTile(x, y)
    if (self:inBounds(x, y)) then
        local tile = self.grid[x][y]
        if (tile ~= nil) then
            return tile
        end
    end
    return nil
end

function Level:inBounds(x, y)
    return x >= 1 and x <= self.gridDimensions.x and y >= 1 and y <= self.gridDimensions.y
end

--- Loops through all Tiles in grid, skipping nil in grid
---@param func function with (tile, x, y)
function Level:tileLoop(func)
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                func(tile, x, y)
            end
        end
    end
end

--- Check tile in the level for collision. Returns { bool: collision?, [empty tile, actor collision or nil] }
---@param position Vector2
---@return table { bool: collision?, [tile.actor, tile.feature, tile or nil] }
function Level:collisionCheck(position)
    if (self:inBounds(position.x, position.y)) then
        local tile = self.grid[position.x][position.y]
        if (tile ~= nil) then
            if (tile.actor ~= nil) then
                return { true, tile.actor } -- collision with actor
            elseif (tile.feature ~= nil and tile.feature.collision == true) then
                return { true, tile.feature } -- collision with feature
            else
                return { false, tile } -- nothing to collide with
            end
        else
            return { true, nil } -- nil tile
        end
    else
        return { true, nil } -- oob
    end
end

--#endregion