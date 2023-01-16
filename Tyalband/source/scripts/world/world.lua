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

function world:setPosition(actor, position)
    position = Vector2.clamp(position, Vector2.one(), self.gridDimensions)

    local tile = self.grid[position.x][position.y]
    if tile.actor == nil then
        actor:updateTile(tile)
        return true
    else
        return false
    end
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

    if (not playdate.buttonIsPressed(playdate.kButtonA)) then
        self:updateLighting()
    end
    screenManager:redrawScreen()
end

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

function world:updateLighting()
    if (self.player.state ~= INACTIVE) then
     
        -- find light sources, if on screen + range then calc

        frameProfiler:startTimer("Logic: Lighting")

        self:tileLoop(function (tile)
            if (tile.seen == true) then
                tile.currentVisibilityState = tile.visibilityState.seen
            else
                tile.currentVisibilityState = tile.visibilityState.unknown
            end
        end)

        local positions = math.findAllCirclePos(self.player.position.x, self.player.position.y, self.player.visionRange)

        for index, pos in ipairs(positions) do
            local x, y = pos[1], pos[2]

            if (not (x < 1) and not (x > self.gridDimensions.x) and not (y < 1) and not (y > self.gridDimensions.y)) then
                local tile = self.grid[pos[1]][pos[2]]
                if (tile ~= nil) then
                    tile.currentVisibilityState = tile.visibilityState.dim
                    tile.seen = true
                end
            end
        end

        local positions = math.findAllCirclePos(self.player.position.x, self.player.position.y, self.player.lightRange)

        for index, pos in ipairs(positions) do
            local x, y = pos[1], pos[2]

            if (not (x < 1) and not (x > self.gridDimensions.x) and not (y < 1) and not (y > self.gridDimensions.y)) then
                local tile = self.grid[pos[1]][pos[2]]
                if (tile ~= nil) then
                    tile.currentVisibilityState = tile.visibilityState.lit
                    tile.seen = true
                end
            end
        end

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

    local startGridX = math.clamp(self.camera.position.x - math.floor(screenXSize*0.5), 1, self.gridDimensions.x-screenXSize + 1)
    local startGridY = math.clamp(self.camera.position.y - math.floor(screenYSize*0.5), 1, self.gridDimensions.y-screenYSize + 1)

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
            
            -- actor > effect > item > deco
                -- flip flop between actor and effect over time?
            local char = ""

            local tile = self.grid[x][y]
            if (tile ~= nil) then
                if tile.actor ~= nil then
                    char = tile.actor.char
                --elseif table.getsize(tile.effects) > 0 then
                --elseif table.getsize(tile.items) > 0 then
                elseif tile.decoration ~= nil then
                    char = tile.decoration.char
                end

                if (tile.currentVisibilityState ~= tile.visibilityState.unknown) then
                    local glyph = screenManager:getGlyph(char, tile.currentVisibilityState)
                    if (tile.currentVisibilityState == tile.visibilityState.lit) then -- draw light around rect
                        gfx.setColor(gfx.kColorWhite)
                        gfx.fillRect(drawCoord.x, drawCoord.y, screenManager.currentWorldFont.size, screenManager.currentWorldFont.size)
                    end
                    glyph:draw(drawCoord.x, drawCoord.y)
                end
            end

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end
end
