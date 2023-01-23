

function ComputeRay(position, visionRange, world, setVisible)

    local _blocksVision = blocksVision or function (x, y)
        if (math.isClamped(x, 1, world.gridDimensions.x) or math.isClamped(y, 1, world.gridDimensions.y)) then
            return false
        end
        local tile = world.grid[x][y]
        if (tile ~= nil) then
            if (tile.actor ~= nil) then
                return tile.actor.blockVision
            end
        end
        return false
    end

    local GetDistance = function (x, y, x2, y2)
        return Vector2.distance_taxi(Vector2.new(x, y), Vector2.new(x2, y2))
    end

    local function TraceLine(position, x2, y2, visionRange)
        local xDiff = x2 - position.x
        local yDiff = y2 - position.y
        local xLen = math.abs(xDiff)
        local yLen = math.abs(yDiff)

        local xInc = math.sign(xDiff)
        local yInc = math.sign(yDiff)<<16
        local index = (position.y<<16) + position.x

        if (xLen < yLen) then
            xLen, yLen = yLen, xLen
            xInc, yInc = yInc, xInc
        end

        local errorInc = yLen*2
        local error = -xLen
        local errorReset = xLen*2

        while (xLen >= 0) do -- todo skip first
            index += xInc;
            error += errorInc
            if (error > 0) then
                error -= errorReset
                index += yInc
            end
            local x, y = index & 0xFFF, index >> 16
            if (visionRange >= 0 and GetDistance(position.x, position.y, x, y) > visionRange) then break end
            setVisible(x, y, 0)
            if (_blocksVision(x, y)) then break end
        end
    end

    setVisible(position.x, position.y, 0)
    if (visionRange ~= 0) then
        local v = visionRange
        local area = {
            top = position.y + v,
            right = position.x + v,
            bottom = position.y - v,
            left = position.x - v
        }

        for x = area.left, area.right-1, 1 do
            TraceLine(position, x, area.top, visionRange)
            TraceLine(position, x, area.bottom-1, visionRange)
        end
        for y = area.top+1, area.bottom-2, 1 do
            TraceLine(position, area.left, y, visionRange)
            TraceLine(position, area.right-1, y, visionRange)
        end
    end
end