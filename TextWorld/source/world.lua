local gfx <const> = playdate.graphics

class("world").extends()

function world:init(theWorldManager, thePlayer)
    self.worldManager = theWorldManager
    self.player = thePlayer

    self.grid = nil
    self.gridDimensions = { x, y }

    self.redrawWorld = true;

    if (self.name == nil) then
        self.name = "World"
    end
    if (self.playerSpawnPosition == nil) then
        self.playerSpawnPosition = { x, y }
    end
    
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ?, 3 = ?, 4 = grass
    self:create()

    self.player:spawn(self, self.playerSpawnPosition.x, self.playerSpawnPosition.y)
    animal(self, 6, 43)
    self.camera = camera(self.player)
    self.camera:update()
end

function world:create()
    -- abstract function to create grid
end

function world:setLocation(actor, x, y)
    x = math.clamp(x, 1, self.gridDimensions.x)
    y = math.clamp(y, 1, self.gridDimensions.y)

    local tile = self.grid[x][y]
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
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil and tile.actor ~= nil and not tile.actor.isa(player)) then
                if tile.actor.updated == false then
                    tile.actor:update()
                else
                    --print("cant update")
                end
            end
        end
    end

    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil and tile.actor ~= nil) then
                tile.actor.updated = false
            end
        end
    end

    self.camera:update() -- must update last to follow
    self.redrawWorld = true;
end

function world:draw()
    if (self.redrawWorld) then
        gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

        gfx.setFont(worldFont)

        local viewport = self.worldManager.viewport

        local screenXSize = math.floor(viewport.width / fontSize)
        local screenYSize = math.floor(viewport.height / fontSize)
        -- TODO replace this math with pre-calcuated shit per font so that the screen is properly placed
        local startGridX = math.clamp(self.camera.x - math.floor(screenXSize*0.5), 1, self.gridDimensions.x-screenXSize+1)
        local startGridY = math.clamp(self.camera.y - math.floor(screenYSize*0.5), 1, self.gridDimensions.y-screenYSize+1)

        local xOffset = 0
        local yOffset = 0
        for xPos = 0, xMax, 1 do
            for yPos = 0, yMax, 1 do

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
        
                    gfx.drawText(char, drawCoord.x, drawCoord.y)
                end

                yOffset += 1
            end
            xOffset += 1
            yOffset = 0
        end

        gfx.setImageDrawMode(defaultDrawMode)
        self.redrawWorld = false;
    end
end
