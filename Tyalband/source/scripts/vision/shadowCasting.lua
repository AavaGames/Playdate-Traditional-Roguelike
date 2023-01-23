
function CastShadow(position, visionRange, world, setVis)

    local blocksVision = function (x, y)
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

    local setVisible = setVis or function (x,y,dist) end

    function _CastShadow(x, y, dx, dy, depth)

        if (depth > visionRange) then return end
        --if (Vector2.distance_taxi(Vector2.new(x,y), Vector2.new(dx,dy)) > visionRange) then return end -- if past visionRange abort

        if blocksVision(x, y) then return end -- check if the current position is a wall

        --local dist = Vector2.distance_taxi(Vector2.new(x,y), Vector2.new(dx,dy))
        setVisible(x, y, 0) -- mark the current position as being in the shadow

        local nx, ny = x + dx, y + dy
        if blocksVision(x, y) then -- if there is a wall in the current direction, don't check diagonally
            _CastShadow(nx, ny, dx, dy, depth + 1)
        else
            -- check diagonally in both directions
            _CastShadow(nx, ny, dx, dy, depth + 1)
            _CastShadow(nx, ny, -dx, -dy, depth + 1)
        end
    end

    for octant = 1, 8, 1 do
        local dx, dy = 0, 0
        if octant == 0 then     dy += 1
        elseif octant == 1 then dx += 1 dy += 1
        elseif octant == 2 then dx += 1
        elseif octant == 3 then dx += 1 dy -= 1
        elseif octant == 4 then dy -= 1
        elseif octant == 5 then dx -= 1 dy -= 1
        elseif octant == 6 then dx -= 1
        elseif octant == 7 then dx -= 1 dy += 1
        end
        _CastShadow(position.x, position.y, dx, dy, 1)
    end

end