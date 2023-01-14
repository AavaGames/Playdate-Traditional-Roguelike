local gfx <const> = playdate.graphics

class("world").extends()

function world:init(theWorldManager, thePlayer)
    self.worldManager = theWorldManager
    self.player = thePlayer

    self.grid = nil
    self.gridDimensions = Vector2.zero()

    if (self.name == nil) then
        self.name = "World"
    end
    if (self.playerSpawnPosition == nil) then
        self.playerSpawnPosition = Vector2.zero()
    end
    
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ?, 3 = ?, 4 = grass
    self:create()

    self.player:spawn(self, self.playerSpawnPosition)
    animal(self, Vector2.new(6, 43))
    self.camera = camera(self.player)
    self.camera:update()
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
    screenManager:redrawWorld()
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
        
        -- find light source, if on screen + range

        --[[
            1. iterate through light sources
            2. check if they are on screen + light range
            3. take their top left most square [x - range][y - range]
            4. iterate a 2D square of range on grid[x + position.x][y + position.y]
            5. FRAME RATE

            or create a Vector2.circle type function which finds all the coords of the circle and itterate through that
        ]]

        -- count how long it takes to do this

        local timer = chunkTimer("Lighting Calculations")

        self:tileLoop(function (tile)
            tile.currentVisibilityState = tile.visibilityState.seen
        end)

        local positions = math.findAllCirclePos(self.player.position.x, self.player.position.y, self.player.visionRange)

        for index, pos in ipairs(positions) do
            local x, y = pos[1], pos[2]

            if (not (x < 1) and not (x > self.gridDimensions.x) and not (y < 1) and not (y > self.gridDimensions.y)) then
                local tile = self.grid[pos[1]][pos[2]]
                if (tile ~= nil) then
                    tile.currentVisibilityState = tile.visibilityState.dim
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
                end
            end
        end
       

        --timer:print()
    end
end

function world:draw()
    print("\n")
    local timer = chunkTimer("World Draw")

    if (not playdate.buttonIsPressed(playdate.kButtonA)) then
        self:updateLighting()
    end

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    gfx.setFont(screenManager.currentWorldFont.font)

    local viewport = self.worldManager.viewport
    local fontSize = screenManager.currentWorldFont.size

    local screenXSize = math.floor(viewport.width / fontSize)
    local screenYSize = math.floor(viewport.height / fontSize)
    -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed

    -- +1?
    local startGridX = math.clamp(self.camera.position.x - math.floor(screenXSize*0.5), 1, self.gridDimensions.x-screenXSize + 1)
    local startGridY = math.clamp(self.camera.position.y - math.floor(screenYSize*0.5), 1, self.gridDimensions.y-screenYSize + 1)

    local xOffset = 0
    local yOffset = 0

    --local worldImage = gfx.image.new(viewport.width, viewport.height)
    --gfx.lockFocus(worldImage)

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
                
                local image = screenManager:getGlyph(char, tile.currentVisibilityState)

                if (tile.currentVisibilityState == 1) then
                    gfx.setColor(gfx.kColorWhite)
                elseif (tile.currentVisibilityState == 2) then
                    gfx.setColor(gfx.kColorBlack)
                elseif (tile.currentVisibilityState == 3) then
                    gfx.setColor(gfx.kColorBlack)
                end
                
                gfx.fillRect(drawCoord.x, drawCoord.y, screenManager.currentWorldFont.size, screenManager.currentWorldFont.size)
                image:draw(drawCoord.x, drawCoord.y)
            end

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end

    --gfx.unlockFocus()
    --worldImage:draw(0, 0)

    --timer:print()
end
