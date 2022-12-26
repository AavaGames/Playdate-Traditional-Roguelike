import "global"
import "player"
import "animal"

local gfx <const> = playdate.graphics

class("world").extends()

worldGrid = {}
actorGrid = {}

function world:init()
    self.insetAmount = 1

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

    self.player = player(1, 0)
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
                    print("cant update")
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
end

function world:draw()
    gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

    --gfx.drawText("THIS IS BASE FONT",0,0)
    local first = self.insetAmount
    local last = self.insetAmount + 1;
    local xOffset = 0
    local yOffset = 0
    for xPos = first, xMax - last, 1 do
        for yPos = first, yMax - last, 1 do
            
            local x = self.player.x + xOffset
            local y = self.player.y + yOffset

            local char = ""
            if actorGrid[x][y] ~= nil then
                char = actorGrid[x][y].char
            else
                char = worldGrid[x][y].char
            end

            gfx.drawText(char, fontSize * xPos, fontSize * yPos)

            yOffset += 1
        end
        xOffset += 1
        yOffset = 0
    end

    gfx.setImageDrawMode(defaultDrawMode)
end