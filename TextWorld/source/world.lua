import "global"
import "player"
import "animal"
import "camera"

local gfx <const> = playdate.graphics

class("world").extends()

worldGrid = {}
actorGrid = {}

function world:init()
    self.insetAmount = 1

    self.xMaxPercentCuttoff = 1
    self.yMaxPercentCuttoff = 0.6

    for x = 0, worldDimension.x - 1, 1 do
        worldGrid[x] = {}
        for y = 0, worldDimension.y - 1, 1 do
            worldGrid[x][y] = entity()
        end
    end

    -- no overlaping with other, can easily check if you can walk on the world location
    -- entity = all things
    -- actor : entity = player, animal, etc
    -- ??? = trees, boulders, etc.
    -- worldEntity = water, grass, dirt, etc ?

    for x = 0, worldDimension.x - 1, 1 do
        actorGrid[x] = {}
        for y = 0, worldDimension.y - 1, 1 do
            actorGrid[x][y] = nil
            if math.random(250) == 1 then 
                animal(x, y)
            end
        end
    end

    self.player = player(math.floor(worldDimension.x/2), math.floor(worldDimension.y/2))
    self.camera = camera(self.player)
    --self.camera = camera(nil, 10, 0) -- not following

    worldGrid[0][0].char = "Z"
    worldGrid[1][5].char = "Z"
end

function world:update()
    for x = 0, worldDimension.x - 1, 1 do
        for y = 0, worldDimension.y - 1, 1 do

            if actorGrid[x][y] ~= nil then
                if actorGrid[x][y].updated == false then
                    actorGrid[x][y]:update()
                else
                    --print("cant update")
                end
            end

        end
    end

    for x = 0, worldDimension.x - 1, 1 do
        for y = 0, worldDimension.y - 1, 1 do
            if actorGrid[x][y] ~= nil then
                actorGrid[x][y].updated = false
            end
        end
    end

    self.camera:update() -- must update last to follow
end

function world:draw()
    gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

    --gfx.drawText("THIS IS BASE FONT",0,0)
    local startX = clamp(self.camera.x - math.floor((xMax-(self.insetAmount*2))/2), 0, worldDimension.x-xMax+(self.insetAmount*2))
    local startY = clamp(self.camera.y - math.floor((yMax-(self.insetAmount*2))/2), 0, worldDimension.y-yMax+(self.insetAmount*2))

    local first = self.insetAmount
    local last = self.insetAmount + 1;
    local xOffset = 0
    local yOffset = 0
    for xPos = first, xMax - last, 1 do
        for yPos = first, yMax - last, 1 do

            local x = startX + xOffset
            local y = startY + yOffset

            if (x > worldDimension.x-1 or y > worldDimension.y-1) then
                break
            end

            local drawCoord = { x = fontSize * xPos, y = fontSize * yPos}
            if (drawCoord.x > screenDimensions.x * self.xMaxPercentCuttoff) then
                xPos = xMax
                break
            end
            if (drawCoord.y > screenDimensions.y * self.yMaxPercentCuttoff) then
                yPos = yMax
                break
            end

            local char = ""
            if actorGrid[x][y] ~= nil then
                char = actorGrid[x][y].char
            else
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