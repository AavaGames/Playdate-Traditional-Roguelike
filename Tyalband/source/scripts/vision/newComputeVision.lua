
function ComputeVision_simple(position, visionRange, world, setVisible, blocksVision)

    -- A function that sets a tile to be visible, given its X and Y coordinates. The function
    -- must ignore coordinates that are out of bounds.
    local _setVisible = setVisible or print("Compute Vision requires a setVisible function")

    -- A function that accepts the X and Y coordinates of a tile and determines whether the
    -- given tile blocks the passage of light. The function must be able to accept coordinates that are out of bounds.
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

    -- A function that takes the X and Y coordinate of a point where X >= 0,
    -- Y >= 0, and X >= Y, and returns the distance from the point to the position (0,0).
    local GetDistance = function (x, y)
        return x + y -- taxicab
    end

    local function BlocksVision(x, y, octant, position)
        local nx = position.x
        local ny = position.y

        if octant == 0 then     nx += x ny -= y
        elseif octant == 1 then nx += y ny -= x
        elseif octant == 2 then nx -= y ny -= x
        elseif octant == 3 then nx -= x ny -= y
        elseif octant == 4 then nx -= x ny += y
        elseif octant == 5 then nx -= y ny += x
        elseif octant == 6 then nx += y ny += x
        elseif octant == 7 then nx += x ny += y
        end

        nx = math.clamp(nx, 1, world.gridDimensions.x)
        ny = math.clamp(ny, 1, world.gridDimensions.y)
        return _blocksVision(nx, ny)
    end

    local function SetVisible(x, y, octant, position, distance)
        local nx = position.x
        local ny = position.y

        if octant == 0 then     nx += x ny -= y
        elseif octant == 1 then nx += y ny -= x
        elseif octant == 2 then nx -= y ny -= x
        elseif octant == 3 then nx -= x ny -= y
        elseif octant == 4 then nx -= x ny += y
        elseif octant == 5 then nx -= y ny += x
        elseif octant == 6 then nx += y ny += x
        elseif octant == 7 then nx += x ny += y
        end

        nx = math.clamp(nx, 1, world.gridDimensions.x)
        ny = math.clamp(ny, 1, world.gridDimensions.y)
        _setVisible(nx, ny, distance)
    end

    local function Compute(octant, position, visionRange, xx, top, bottom)  
        local t = chunkTimer("Octant" .. octant)
        for x = xx, visionRange, 1 do

            local topY
            if (top.x == 1) then        
                topY = x
            else
                topY = ((x*2-1) * top.y + top.x) // (top.x*2)
                if BlocksVision(x, topY, octant, position) then
                    if (top:greaterOrEqual(topY*2+1, x*2) and not BlocksVision(x, topY+1, octant, position)) then
                        topY += 1
                    end
                else
                    local ax = x*2 
                    if(BlocksVision(x+1, topY+1, octant, position)) then
                        ax += 1
                    end
                    if(top:greater(topY*2+1, ax)) then
                        topY += 1
                    end 
                end

            end

            local bottomY
            if(bottom.y == 0) then
                bottomY = 0
            else
                bottomY = ((x*2-1) * bottom.y + bottom.x) // (bottom.x*2)
                if(bottom:greaterOrEqual(bottomY*2+1, x*2) and BlocksVision(x, bottomY, octant, position)
                    and not BlocksVision(x, bottomY+1, octant, position)) then
                    bottomY += 1
                end
            end
            
            local wasOpaque = -1 -- 0:false, 1:true, -1:not applicable
            for y = topY, bottomY, -1 do

                local distance = GetDistance(x, y)
                if(visionRange < 0 or distance <= visionRange) then
                
                    local isOpaque = BlocksVision(x, y, octant, position)

                    local isVisible
                    if (not symmetry) then
                        --isVisible = isOpaque or ((y ~= topY or top:greater(y*4-1, x*4+1)) and (y ~= bottomY or bottom:less(y*4+1, x*4-1)))
                    else
                        --the line ensures that a clear tile is visible only if there's an unobstructed line to its center.
                        -- NOTE: completely symmetrical remove "isOpaque or"
                        if (perfectSym) then
                            isVisible = ((y ~= topY or top:greaterOrEqual(y, x)) and (y ~= bottomY or bottom:lessOrEqual(y, x)))
                        else
                            isVisible = isOpaque or ((y ~= topY or top:greaterOrEqual(y, x)) and (y ~= bottomY or bottom:lessOrEqual(y, x)))
                        end
                    end
                    

                    if(isVisible) then
                        SetVisible(x, y, octant, position, distance)
                    end

                    if (x ~= visionRange) then
                    
                        if(isOpaque) then
                        
                            if(wasOpaque == 0) then
                                local nx = x*2
                                local ny = y*2+1
                                if (not symmetry) then
                                    -- NOTE: if you're using full symmetry and want more expansive walls (recommended), comment out the next if
                                    if(BlocksVision(x, y+1, octant, position)) then
                                        nx -= 1 
                                    end
                                end
                                

                                if(top:greater(ny, nx)) then
                                       
                                    if (y == bottomY) then
                                        bottom = slope(ny, nx) 
                                        break
                                    else 
                                        Compute(octant, position, visionRange, x+1, top, slope(ny, nx))
                                    end
                                else 
                                    if(y == bottomY) then
                                        return
                                    end 
                                end

                            end
                            wasOpaque = 1
                        else
                        
                            if(wasOpaque > 0) then
                                local nx = x*2
                                local ny = y*2+1 

                                if (not symmetry) then
                                    -- NOTE: if you're using full symmetry and want more expansive walls (recommended), comment out the next if
                                    if(BlocksVision(x+1, y+1, octant, position)) then
                                        nx += 1
                                    end 
                                end

                                if(bottom:greaterOrEqual(ny, nx)) then
                                    return
                                end
                                top = slope(ny, nx)
                            end
                            wasOpaque = 0
                        end
                    end
                end
            end
            if(wasOpaque ~= 0) then
                break
            end
        end
        --t:print()
    end

    _setVisible(position.x, position.y, 0)

    for octant = 0, 7, 1 do
        Compute(octant, position, visionRange, 1, slope(1, 1), slope(0, 1))
    end
end
