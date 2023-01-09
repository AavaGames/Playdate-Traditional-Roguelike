local gfx <const> = playdate.graphics

class("world").extends()

function world:init(theWorldManager, thePlayer)
    self.worldManager = theWorldManager
    self.player = thePlayer

    self.grid = nil
    self.gridDimensions = { x, y }

    if (self.name == nil) then
        self.name = "World"
    end
    if (self.playerSpawnPosition == nil) then
        self.playerSpawnPosition = { x, y }
    end
    
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ?, 3 = ?, 4 = grass
    self:create()

    print(self.grid)

    self.player:spawn(self, self.playerSpawnPosition.x, self.playerSpawnPosition.y)
    self.camera = camera(self.player)
end

function world:create()
    -- abstract function to create grid
end

function world:setLocation(actor, x, y)
    x = clamp(x, 1, self.gridDimensions.x)
    y = clamp(y, 1, self.gridDimensions.y)

    local tile = self.grid[x][y]
    if tile.actor == nil then
        actor:updateTile(tile)
        return true
    else
        return false
    end
end

function world:update()
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local tile = self.grid[x][y]
            if (tile ~= nil and tile.actor ~= nil) then
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
end

function world:draw()
    gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

    gfx.setFont(worldFont)

    local screenX = xMax-(self.worldManager.insetAmount*2)
    local screenY = yMax-(self.worldManager.insetAmount*2)
    local startX = clamp(self.camera.x - math.floor(screenX/2), 1, self.gridDimensions.x-screenX + 1)
    local startY = clamp(self.camera.y - math.floor(screenY/2), 1, self.gridDimensions.y-screenY + 1)

    local first = self.worldManager.insetAmount
    local last = self.worldManager.insetAmount + 1;
    local xOffset = 0
    local yOffset = 0

    for xPos = first, xMax - last, 1 do
        for yPos = first, yMax - last, 1 do
            local x = startX + xOffset
            local y = startY + yOffset

            if (x > self.gridDimensions.x or y > self.gridDimensions.y) then
                break
            end

            local drawCoord = { x = fontSize * xPos, y = fontSize * yPos}
            if (drawCoord.x > screenDimensions.x * self.worldManager.xMaxPercentCutoff) then
                xPos = xMax
                break
            end
            if drawCoord.y > screenDimensions.y * self.worldManager.yMaxPercentCutoff or 
                (showLog and drawCoord.y > screenDimensions.y * self.worldManager.logYMaxPercentCutoff) then
                yPos = yMax
                break
            end
            drawCoord.x += self.worldManager.drawOffset.x
            drawCoord.y += self.worldManager.drawOffset.y

            -- actor > effect > item > deco
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
end
