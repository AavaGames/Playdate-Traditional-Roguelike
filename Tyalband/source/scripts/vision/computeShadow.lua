function ComputeShadow(position, visionRange, world, setVisible, blocksVision)

    -- A function that sets a tile to be visible, given its X and Y coordinates. The function
    -- must ignore coordinates that are out of bounds.
    local _setVisible = setVisible or print("Compute Vision requires a setVisible function")
    -- local _setVisible = function (x, y, distance) -- set visible
    --     local tile = world.grid[x][y]
    --     if (tile ~= nil) then
    --         tile.inView = true
    --         print("tile visible")
    --         if (distance <= world.player.visionRange) then
    --             tile.currentVisibilityState = tile.visibilityState.lit
    --             tile:addLightLevel(2, world.player.equipped.lightSource)
    --             tile.seen = true
    --         else
    --         end
    --     end
    -- end


    -- A function that accepts the X and Y coordinates of a tile and determines whether the
    -- given tile blocks the passage of light. The function must be able to accept coordinates that are out of bounds.
    local _blocksVision = blocksVision or function (x, y)
        local tile = world.grid[x][y]
        if (tile ~= nil) then
            if (tile.actor ~= nil) then
                return tile.actor.blockVision
            end
        end
        return false
    end

    local GetDistanceToOrigin = function (x, y, origin)
        return Vector2.distance_taxi(Vector2.new(x, y), Vector2.new(origin.x, origin.y))
    end

    local function Compute(octant, origin, rangeLimit, xx, top, bottom)

        rangeLimit = 4

        for x = xx, rangeLimit, 1 do
            local topY = top.x == 1 and x or ((x*2+1) * top.y + top.x - 1) // (top.x*2)
            local bottomY = bottom.y == 0 and 0 or ((x*2-1) * bottom.y + bottom.x) // (bottom.x*2)

            local wasOpaque = -1
            for y = topY, bottomY, -1 do
                local nx = origin.x
                local ny = origin.y

                if octant == 0 then     nx += x ny -= y
                elseif octant == 1 then nx += y ny -= x
                elseif octant == 2 then nx -= y ny -= x
                elseif octant == 3 then nx -= x ny -= y
                elseif octant == 4 then nx -= x ny += y
                elseif octant == 5 then nx -= y ny += x
                elseif octant == 6 then nx += y ny += x
                elseif octant == 7 then nx += x ny += y
                end

                local distance = rangeLimit < 0 and 0 or GetDistanceToOrigin(nx, ny, origin )

                local inRange = distance <= rangeLimit

                if (inRange == true) then
                    _setVisible(nx, ny, distance)
                end
                local blocksVision = _blocksVision(nx, ny)
                local isOpaque = not inRange or blocksVision

                if (x ~= rangeLimit) then
                    if (isOpaque == true) then
                        if (wasOpaque == 0) then

                            local newBottom = slope_shadow(y*2+1, x*2+1)

                            if (not inRange or y == bottomY) then

                                bottom = newBottom
                                break

                            else 
                                print("recompute")
                                Compute(octant, origin, rangeLimit, x+1, top, newBottom)
                            end

                        end

                        wasOpaque = 1

                    else

                        if (wasOpaque > 0) then
                            top = slope_shadow(y*2+1, x*2+1)
                            wasOpaque = 0
                        end

                    end
                end

                if (wasOpaque ~= 0) then
                    break
                end

            end        
        end
    end

    _setVisible(position.x, position.y, 0)

    for octant = 0, 7, 1 do
        Compute(octant, position, visionRange, 1, slope_shadow(1, 1), slope_shadow(0, 1))
    end
end

class("slope_shadow").extends()

function slope_shadow:init(y, x)
    self.y = y
    self.x = x
end