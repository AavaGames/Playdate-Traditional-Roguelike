local gfx <const> = playdate.graphics

class("World").extends()

function World:init(theWorldManager, thePlayer)
    self.worldManager = theWorldManager
    self.player = thePlayer

    self.name = "World" -- Floor X (Depth 50*X)
    self.playerSpawnPosition = Vector2.zero()

    self.worldIsLit = false
    self.worldIsSeen = false

    self.grid = nil
    self.gridDimensions = Vector2.zero()

    self.actors = {}
    self.effects = {}

    self.visionTiles = nil

    self.toPlayerPathMap = nil
    self.smellMap = nil
    self.soundMap = nil

    self:create()
end

function World:finishInit()
    if (self.worldIsSeen == true) then
        self:tileLoop(function (tile)
            tile.seen = true
        end)
    end
    screenManager:setWorldColor(self.worldIsLit == true and gfx.kColorWhite or gfx.kColorBlack)
    self.player:spawn(self, self.playerSpawnPosition)
    self.camera = Camera(self.player)

    -- setup vision / light
    self:tileLoop(function (tile)
        if (tile.glow == true) then
            tile:resetLightLevel(2)
            tile.seen = true
        else
            tile:resetLightLevel()
        end

        if (self.worldIsLit) then
            tile:addLightLevel(2, "World")
            tile.seen = true
        end

        if (tile.seen == true) then
            tile.currentVisibilityState = tile.visibilityState.seen
        else
            tile.currentVisibilityState = tile.visibilityState.unknown
        end
    end)

    self.toPlayerPathMap = FloodMap.new(self.gridDimensions.x, self.gridDimensions.y)
	self.toPlayerPathMap:addSource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    self.smellMap = FloodMap.new(self.gridDimensions.x, self.gridDimensions.y)
	self.smellMap:addSource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    self.soundMap = FloodMap.new(self.gridDimensions.x, self.gridDimensions.y)
	self.soundMap:addSource(self.playerSpawnPosition.x, self.playerSpawnPosition.y, 1)

    self:tileLoop(function (tile)
        if (tile.blocksLight) then
            self.toPlayerPathMap:setTileColliding(tile.position.x, tile.position.y)
            self.smellMap:setTileColliding(tile.position.x, tile.position.y)
            self.soundMap:setTileColliding(tile.position.x, tile.position.y)
        end
    end)

    self:updatePathfindingMaps()
    if (not self.worldIsLit) then
        self:updateView()
    end
end

function World:create()
    -- abstract function to create grid
end

function World:update()
    -- if (inputManager:JustPressed(playdate.kButtonA)) then
    --     print("up")
    --     self.player.equipped.lightSource.dimRange += 2
    -- elseif (inputManager:JustPressed(playdate.kButtonB)) then
    --     print("dowmn")
    --     self.player.equipped.lightSource.dimRange -= 2
    -- end
end

function World:lateUpdate()
    
end

function World:round()
    frameProfiler:startTimer("Logic: Actor Update")
    
    local actorMax = #self.actors
    for i = 1, actorMax, 1 do
        self.actors[i]:tick(); -- rename to monsters? cause player aint here
    end
    self.camera:update() -- must update last to follow player

    frameProfiler:endTimer("Logic: Actor Update")

    self:updatePathfindingMaps()
    self:updateView()

    screenManager:redrawWorld()
end

--region Drawing & Lighting

function World:updateView()
    frameProfiler:startTimer("Logic: Vision")

    -- TODO loop / find light sources, if on screen + range then calc
    local litActor = self.player
    
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

                    if (self.worldIsLit) then
                        tile:addLightLevel(2, "World")
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
    frameProfiler:endTimer("Vision: Reset")
    
    frameProfiler:startTimer("Vision: Visible")
    self.visionTiles = math.findAllDiamondPos(litActor.position.x, litActor.position.y, litActor.visionRange)
    frameProfiler:endTimer("Vision: Visible")

    frameProfiler:startTimer("Vision: Apply Vis")
    local max = #self.visionTiles
    for i = 1, max, 1 do
        local x, y, distance = self.visionTiles[i][1], self.visionTiles[i][2], self.visionTiles[i][3]

        -- SetVisible
        if (self:inBounds(x, y)) then
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                if (distance <= litActor.equipped.lightSource.litRange) then
                    tile.currentVisibilityState = tile.visibilityState.lit
                    tile:addLightLevel(2, litActor.equipped.lightSource)
                    tile.seen = true
                elseif (distance <= litActor.equipped.lightSource.dimRange) then
                    tile.currentVisibilityState = tile.visibilityState.dim
                    tile:addLightLevel(1, litActor.equipped.lightSource)
                    tile.seen = true
                end
            end
        end

    end
    frameProfiler:endTimer("Vision: Apply Vis")

    frameProfiler:endTimer("Logic: Vision")
end

function World:updatePathfindingMaps()
    frameProfiler:startTimer("Pathfinding")
    -- update source position and fill out map
    -- TODO update djikstra only when someone asks for it
    frameProfiler:startTimer("Pathfinding: toPlayerPath")
    self.toPlayerPathMap:addSource(self.player.position.x, self.player.position.y, 1)
    self.toPlayerPathMap:fillMap()
    frameProfiler:endTimer("Pathfinding: toPlayerPath")

    self.smellMap:addSource(self.player.position.x, self.player.position.y, 1)
    self.smellMap:fillMap()

    self.soundMap:addSource(self.player.position.x, self.player.position.y, 1)
    self.soundMap:fillMap()
    frameProfiler:endTimer("Pathfinding")
end

function World:draw()
    local screenManager = screenManager
    print("\n")
    local viewport = self.worldManager.viewport
    local fontSize = screenManager.currentWorldFont.size

    local screenXSize = math.floor(viewport.width / fontSize)
    local screenYSize = math.floor(viewport.height / fontSize)
    -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed

    local startTileX = math.clamp(self.camera.position.x - math.floor(screenXSize*0.5), 1, 
        math.clamp(self.gridDimensions.x-screenXSize + 1, 1, 9999999)) -- hard code screen size to font
    local startTileY = math.clamp(self.camera.position.y - math.floor(screenYSize*0.5), 1, 
        math.clamp(self.gridDimensions.y-screenYSize + 1, 1, 9999999))

    local xOffset = 0
    local yOffset = 0

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(screenManager.currentWorldFont.font)

    for xPos = 0, screenManager.gridScreenMax.x, 1 do
        for yPos = 0, screenManager.gridScreenMax.y, 1 do

            local x = startTileX + xOffset
            local y = startTileY + yOffset

            if (x > self.gridDimensions.x or y > self.gridDimensions.y) then
                break
            end
            local drawCoord = { 
                x = viewport.x + fontSize * xPos,
                y = viewport.y + fontSize * yPos
            }   
            if drawCoord.x > (viewport.width) then
                break
            end
            if drawCoord.y > (viewport.height) then
                break
            end

            -- TODO create some sort of dijkstra map debug drawer - can create a debug menu with the cycles of maps
            -- If > 10+ then use letters lowercase -> upper

            local char = ""
            local tile = self.grid[x][y]
            if (tile ~= nil and tile.currentVisibilityState ~= tile.visibilityState.unknown) then 
                if tile.actor ~= nil and tile.lightLevel > 0 then
                    char = tile.actor:getChar()
                elseif #tile.effects > 0 then
                    -- TODO add effects & drawing
                elseif tile.item ~= nil and (tile.lightLevel > 0 or tile.item.seen == true) then
                    char = tile.item.char
                    tile.item.seen = true 
                        -- probably move this somewhere else
                        -- item checks if tile is seen every frame? seems inefficient
                elseif tile.feature ~= nil then -- features: walls, ground
                    char = tile.feature:getChar()
                end
            end

            screenManager:drawGlyph(char, tile, drawCoord, { 
                x = xPos,
                y = yPos
            })
        
            -- gfx.setFont(screenManager.logFont_6px.font)
            -- gfx.drawText((xPos), drawCoord.x, drawCoord.y)

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end
end

--#endregion

--Pass in a function for the the tile to run through ( function(tile) )
function World:tileLoop(func)
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                func(tile)
            end
        end
    end
end

function World:inBounds(x, y)
    return x >= 1 and x <= self.gridDimensions.x and y >= 1 and y <= self.gridDimensions.y
end

-- Check tile in the world for collision. Returns { bool: collision?, [empty tile, actor collision or nil] }
function World:collisionCheck(position)
    if (self:inBounds(position.x, position.y)) then
        local tile = self.grid[position.x][position.y]
        if (tile ~= nil) then
            if (tile.actor ~= nil and tile.actor == true) then
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

function World:spawnAt(position, actor)

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

function World:despawn(actor)
    --table.remove(self.actors, actor.index)
end