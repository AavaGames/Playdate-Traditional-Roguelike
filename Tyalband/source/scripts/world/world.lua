local gfx <const> = playdate.graphics

class("world").extends()

function world:init(theWorldManager, thePlayer)
    self.worldManager = theWorldManager
    self.player = thePlayer

    self.grid = nil
    self.gridDimensions = Vector2.zero()

    self.name = "World" -- Floor X (Depth 50*X)
    self.playerSpawnPosition = Vector2.zero()

    self.worldIsLit = false
    self.worldIsSeen = false

    self:create()
end

function world:finishInit()
    if (self.worldIsSeen == true) then
        self:tileLoop(function (tile)
            tile.seen = true
        end)
    end
    screenManager:setWorldColor(self.worldIsLit == true and gfx.kColorWhite or gfx.kColorBlack)
    self.player:spawn(self, self.playerSpawnPosition)
    self.camera = camera(self.player)
    self:updateLighting()
end

function world:create()
    -- abstract function to create grid
end

function world:update()

end

function world:lateUpdate()
    
end

function world:round()
    --print("round")

    frameProfiler:startTimer("Logic: Actor Update")

    -- TODO optimize, takes about 77ms to calculate. Could keep all actors / effects in a table and just iterate that
    self:tileLoop(function (tile)
        if (tile ~= nil and tile.actor ~= nil and not tile.actor.isa(player)) then
            if tile.actor.updated == false then
                tile.actor:update()
            else
                --print("cant update")
            end
        end
    end)

    self:tileLoop(function (tile)
        if (tile ~= nil and tile.actor ~= nil) then
            tile.actor.updated = false
        end
    end)
    
    self.camera:update() -- must update last to follow

    frameProfiler:endTimer("Logic: Actor Update")

    self:updateLighting()
    screenManager:redrawScreen()
end

--region Drawing & Lighting

function world:updateLighting()
    if (self.player.state ~= INACTIVE) then
     
        -- find light sources, if on screen + range then calc

        frameProfiler:startTimer("Logic: Lighting")

        -- reset tiles
        self:tileLoop(function (tile)
            if (tile.seen == true) then
                tile.currentVisibilityState = tile.visibilityState.seen
            else
                tile.currentVisibilityState = tile.visibilityState.unknown
            end
            tile.inView = false
            tile.lightLevel = 0
            if (self.worldIsLit) then
                tile:addLightLevel(2)
            end
        end)

        ComputeVision(self.player.position, self.player.visionRange, self.player.equipped.lightSource, self,
        function (x, y, distance) -- set visible

            local tile = self.grid[x][y]
            if (tile ~= nil) then
                tile.inView = true

                if (distance <= self.player.equipped.lightSource.litRange) then
                    tile.currentVisibilityState = tile.visibilityState.lit
                    tile:addLightLevel(2)
                    tile.seen = true
                elseif (distance <= self.player.equipped.lightSource.dimRange) then
                    tile.currentVisibilityState = tile.visibilityState.dim
                    tile:addLightLevel(1)
                    tile.seen = true
                else
                    -- in view but not light
                end
                
            end

        end)

        

        -- local positions = math.findAllCirclePos(self.player.position.x, self.player.position.y, self.player.visionRange)

        -- for index, pos in ipairs(positions) do
        --     local x, y = pos[1], pos[2]

        --     if (not (x < 1) and not (x > self.gridDimensions.x) and not (y < 1) and not (y > self.gridDimensions.y)) then
        --         local tile = self.grid[pos[1]][pos[2]]
        --         if (tile ~= nil) then
        --             tile.currentVisibilityState = tile.visibilityState.dim
        --             tile.seen = true
        --         end
        --     end
        -- end

        -- local positions = math.findAllCirclePos(self.player.position.x, self.player.position.y, self.player.lightRange)

        -- for index, pos in ipairs(positions) do
        --     local x, y = pos[1], pos[2]

        --     if (not (x < 1) and not (x > self.gridDimensions.x) and not (y < 1) and not (y > self.gridDimensions.y)) then
        --         local tile = self.grid[pos[1]][pos[2]]
        --         if (tile ~= nil) then
        --             tile.currentVisibilityState = tile.visibilityState.lit
        --             tile.seen = true
        --         end
        --     end
        -- end

        frameProfiler:endTimer("Logic: Lighting")
    end
end

function world:draw()
    print("\n")
    local viewport = self.worldManager.viewport
    local fontSize = screenManager.currentWorldFont.size

    local screenXSize = math.floor(viewport.width / fontSize)
    local screenYSize = math.floor(viewport.height / fontSize)
    -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed

    local startGridX = math.clamp(self.camera.position.x - math.floor(screenXSize*0.5), 1, 
        math.clamp(self.gridDimensions.x-screenXSize + 1, 1, 9999999)) -- hard code screen size to font
    local startGridY = math.clamp(self.camera.position.y - math.floor(screenYSize*0.5), 1, 
        math.clamp(self.gridDimensions.y-screenYSize + 1, 1, 9999999))

    local xOffset = 0
    local yOffset = 0

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(screenManager.currentWorldFont.font)

    for xPos = 0, screenManager.gridScreenMax.x, 1 do
        for yPos = 0, screenManager.gridScreenMax.y, 1 do

            local x = startGridX + xOffset
            local y = startGridY + yOffset

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

            local tile = self.grid[x][y]
            if (tile ~= nil and tile.currentVisibilityState ~= tile.visibilityState.unknown) then
                -- actor > effect > item > deco
                    -- flip flop between actor and effect over time?
                local char = ""

                if tile.actor ~= nil and tile.inView and tile.lightLevel > 0 then
                    char = tile.actor:getChar()
                elseif tile.actor ~= nil and tile.actor.renderWhenSeen and tile.seen then
                    char = tile.actor:getChar()
                elseif #tile.effects > 0 then
                    -- TODO
                elseif tile.item ~= nil and (tile.lightLevel > 0 or tile.item.seen == true) then
                    char = tile.item.char
                    tile.item.seen = true -- probably move this somewhere else
                elseif tile.decoration ~= nil then
                    char = tile.decoration.char
                end
                

                local glyph = screenManager:getGlyph(char, tile.inView, tile.lightLevel)
                if (tile.currentVisibilityState == tile.visibilityState.lit or tile.currentVisibilityState == tile.visibilityState.dim) then -- draw light around rect
                    gfx.setColor(gfx.kColorWhite)
                    gfx.fillRect(drawCoord.x, drawCoord.y, screenManager.currentWorldFont.size, screenManager.currentWorldFont.size)
                end
                glyph:draw(drawCoord.x, drawCoord.y)
            end

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end
end

--#endregion

--Pass in a function for the the tile to run through ( function(tile) )
function world:tileLoop(func)
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                func(tile)
            end
        end
    end
end

-- Check tile in the world for collision. Returns { bool: collision?, [empty tile, actor collision or nil] }
function world:collisionCheck(position)
    if (math.isClamped(position.x, 1, self.gridDimensions.x) or math.isClamped(position.y, 1, self.gridDimensions.y)) then
        return { true, nil } -- oob
    end
    local tile = self.grid[position.x][position.y]
    if (tile ~= nil) then
        if (tile.actor ~= nil) then
            if (tile.actor.collision == true) then
                return { true, tile.actor }
            else
                return { false, tile }-- no collision with actor
            end
        else
            return { false, tile } -- no actor to collide with
        end
    else
        return { true, nil } -- nil tile
    end
end

function world:spawnAt(position)
    --[[
        collision check spawn area
        What to do if something blocks the area? spawn in a sweeping circle around it.
            same code at item placement
    ]]

    if (self:collisionCheck(position)) then
        
    else
        return true
    end
end