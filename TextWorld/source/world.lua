local gfx <const> = playdate.graphics

class("world").extends()

function world:init(theWorldManager)
    self.worldManager = theWorldManager

    self.grid = {}
    self.gridDimensions = { x, y }

    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ground, 3 = nil, 4 = grass

    local townFile = playdate.file.open("assets/maps/town.json")
    local townJson = json.decodeFile(townFile)
    local townArray = townJson.layers[1].data
    self.gridDimensions = { x = townJson.width, y = townJson.height }
    
    -- init table
    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)
    end

    -- populate map
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local width = self.gridDimensions.x
            local index = x + width * (y-1)
            local type = townArray[index]

            if (type > 0) then
                self.grid[x][y] = tile()
            else
                self.grid[x][y] = nil
            end
    
            local tile = self.grid[x][y]
            if type == 1 then
                wall(self, x, y)
            elseif type == 3 then
                --tile.decoration = ground()
            elseif type == 4 then
                tile.decoration = grass()
            end

        end
    end

    print(self.grid[15][self.gridDimensions.y].actor.char)

    --self.player = player(math.floor(self.gridDimensions.x/2), math.floor(self.gridDimensions.y/2))
    self.player = player(self, 16,53)
    self.camera = camera(self.player)
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

    local screenX = xMax-(worldManager.insetAmount*2)
    local screenY = yMax-(worldManager.insetAmount*2)
    local startX = clamp(self.camera.x - math.floor(screenX/2), 1, self.gridDimensions.x-screenX + 1)
    local startY = clamp(self.camera.y - math.floor(screenY/2), 1, self.gridDimensions.y-screenY + 1)

    local first = worldManager.insetAmount
    local last = worldManager.insetAmount + 1;
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
            if (drawCoord.x > screenDimensions.x * worldManager.xMaxPercentCutoff) then
                xPos = xMax
                break
            end
            if drawCoord.y > screenDimensions.y * worldManager.yMaxPercentCutoff or 
                (showLog and drawCoord.y > screenDimensions.y * worldManager.logYMaxPercentCutoff) then
                yPos = yMax
                break
            end
            drawCoord.x += worldManager.drawOffset.x
            drawCoord.y += worldManager.drawOffset.y

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
