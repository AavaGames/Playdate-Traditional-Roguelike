local gfx <const> = playdate.graphics

class("Level").extends()

function Level:init(theLevelManager, thePlayer)
    self.levelManager = theLevelManager
    self.player = thePlayer
    self.healthDisplay = HealthDisplay(self.player)

    self.name = "Level"
    self.playerSpawnPosition = Vector2.zero()

    self.FullyLit = false
    self.FullySeen = false

    self.grid = nil
    self.gridDimensions = Vector2.zero()

    self.actors = {}
    self.effects = {}

    self.visionTiles = nil

    self.distanceMapManager = nil

    self.debugDrawDistMap = false
    self.debugDistMap = "toPlayerPathMap"

    self:create()
end

function Level:finishInit()
    if (self.FullySeen == true) then
        self:tileLoop(function (tile)
            tile.seen = true
        end)
    end
    screenManager:setBGColor(self.FullyLit == true and gfx.kColorWhite or gfx.kColorBlack)
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
    end)

    if (not self.FullyLit) then
        self:updateView()
    end
end

function Level:create()
    -- abstract function to create grid
end

function Level:update() end
function Level:lateUpdate() end

-- Called by player on action taken
function Level:round(playerMoved)
    frameProfiler:startTimer("Logic: Actor Update")

    self.distanceMapManager:reset()

    local actorMax = #self.actors
    for i = 1, actorMax, 1 do
        self.actors[i]:round(); -- rename to monsters? cause player aint here
    end

    self.camera:update() -- must update last to follow player, if anything moved them

    frameProfiler:endTimer("Logic: Actor Update")

    if (playerMoved == true) then
        self:updateView() -- rework for multi lights
    end

    screenManager:redrawLevel()
end

--region Drawing & Lighting

function Level:updateView()
    frameProfiler:startTimer("Logic: Vision")

    frameProfiler:startTimer("Vision: Reset")

    -- optimize further by just resetting the tiles not seen anymore
    if (self.visionTiles ~= nil) then
        local max = #self.visionTiles
        for i = 1, max, 1 do
            local x, y = self.visionTiles[i][1], self.visionTiles[i][2]
            -- Reset previous lit tiles
            if (self:inBounds(x, y)) then
                local tile = self.grid[x][y]
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
            if (self:inBounds(x, y)) then
                local tile = self.grid[x][y]
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
            local tile = nil
            if (self:inBounds(x, y)) then
                tile = self.grid[x][y]
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

function Level:inBounds(x, y)
    return x >= 1 and x <= self.gridDimensions.x and y >= 1 and y <= self.gridDimensions.y
end

--Pass in a function for the the tile to run through ( function(tile) )
function Level:tileLoop(func)
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                func(tile)
            end
        end
    end
end

-- Check tile in the level for collision. Returns { bool: collision?, [empty tile, actor collision or nil] }
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

function Level:spawnAt(position, actor)

    table.insert(self.actors, actor)
    actor:moveTo(position)

    --[[
        collision check spawn area
        What to do if something blocks the area? spawn in a sweeping circle around it.
            same code at item placement
    ]]

    -- if (self:collisionCheck(position)) then
    --     table.insert(self.actors, actor)
    --     -- give actor the index so it can then remove itself?
    --     -- keep track of an index and place actors there to make sure no interferance
    -- else
    --     return true
    -- end
end

function Level:despawn(actor)
    --table.remove(self.actors, actor.index)
end