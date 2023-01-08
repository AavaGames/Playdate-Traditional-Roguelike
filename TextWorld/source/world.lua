import "global"
import "player"
import "animal"
import "camera"

local gfx <const> = playdate.graphics

class("world").extends()

worldGrid = {}
actorGrid = {}

gridDimensions = { x, y }

function world:init()
    self.insetAmount = 1

    self.xMaxPercentCuttoff = 1
    self.yMaxPercentCuttoff = 0.6

    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ground, 3 = nil, 4 = grass

    local townFile = playdate.file.open("assets/maps/town.json")
    local townJson = json.decodeFile(townFile)
    townArray = townJson.layers[1].data
    gridDimensions = { x = townJson.width, y = townJson.height }

    print (gridDimensions.x, gridDimensions.y, townArray[1], townArray[gridDimensions.y * gridDimensions.x])

    for x = 1, gridDimensions.x, 1 do
        worldGrid[x] = {}
        for y = 1, gridDimensions.y, 1 do
            local type = townArray[y * gridDimensions.x * x]

            if type == 1 then
                worldGrid[x][y] = entity()
            else
                worldGrid[x][y] =  nil
            end
            
        end
    end

    printTable(townArray)

    -- worldGrid[math.floor(worldDimension.x/2) -2][math.floor(worldDimension.y/2)-2].char = "Z"
    -- worldGrid[math.floor(worldDimension.x/2) +2][math.floor(worldDimension.y/2)+2].char = "Z"

    for x = 0, gridDimensions.x - 1, 1 do
        actorGrid[x] = {}
        for y = 0, gridDimensions.y - 1, 1 do
            actorGrid[x][y] = nil
            -- if math.random(250) == 1 then 
            --     animal(x, y)
            -- end
        end
    end


    --self.player = player(math.floor(worldDimension.x/2), math.floor(worldDimension.y/2))
    self.player = player(15,0)
    self.camera = camera(self.player)
end

function world:update()
    for x = 0, gridDimensions.x - 1, 1 do
        for y = 0, gridDimensions.y - 1, 1 do

            if actorGrid[x][y] ~= nil then
                if actorGrid[x][y].updated == false then
                    actorGrid[x][y]:update()
                else
                    --print("cant update")
                end
            end

        end
    end

    for x = 0, gridDimensions.x - 1, 1 do
        for y = 0, gridDimensions.y - 1, 1 do
            if actorGrid[x][y] ~= nil then
                actorGrid[x][y].updated = false
            end
        end
    end

    self.camera:update() -- must update last to follow
end

function world:draw()
    gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

    gfx.setFont(baseFont)

    local startX = clamp(self.camera.x - math.floor((xMax-(self.insetAmount*2))/2), 1, gridDimensions.x-xMax+(self.insetAmount*2))
    local startY = clamp(self.camera.y - math.floor((yMax-(self.insetAmount*2))/2), 1, gridDimensions.y-yMax+(self.insetAmount*2))

    local first = self.insetAmount
    local last = self.insetAmount + 1;
    local xOffset = 0
    local yOffset = 0

    for xPos = first, xMax - last, 1 do
        for yPos = first, yMax - last, 1 do

            local x = startX + xOffset
            local y = startY + yOffset

            if (x > gridDimensions.x or y > gridDimensions.y) then
                break
            end

            local drawCoord = { x = fontSize * xPos, y = fontSize * yPos}
            if (drawCoord.x > screenDimensions.x * self.xMaxPercentCuttoff) then
                xPos = xMax
                break
            end
            if (showLog and drawCoord.y > screenDimensions.y * self.yMaxPercentCuttoff) then
                yPos = yMax
                break
            end

            local char = ""
            if actorGrid[x][y] ~= nil then
                char = actorGrid[x][y].char
            elseif worldGrid[x][y] ~= nil then
                char = worldGrid[x][y].char
            end

            gfx.drawText(char, drawCoord.x, drawCoord.y)

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end

    gfx.setImageDrawMode(defaultDrawMode)
end