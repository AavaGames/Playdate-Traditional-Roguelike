-- Takes a Vector2 Origin and an int RangeLimit

local symmetry = false

function ComputeVision(position, rangeLimit, world)

    local _blocksLight = function (x, y)

        
        local tile = world.grid[x][y]
        if (tile ~= nil) then
            --tile.currentVisibilityState = tile.visibilityState.seen

            if (tile.actor ~= nil) then
                if (tile.actor.name == "Wall") then
                    return true
                end
            end
            --return tile.blocksLight

        end
        return false
    end

    local GetDistance = function (x, y)
        
        return math.sqrt(x^2 + y^2)
        --return math.max(x,y)
    end

    local _setVisible = function (x, y)

        local tile = world.grid[x][y]
        if (tile ~= nil) then
            tile.currentVisibilityState = tile.visibilityState.lit
            tile.seen = true
        end

    end

    local function BlocksLight(x, y, octant, position) 
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
        return _blocksLight(nx, ny)
    end

    local function SetVisible(x, y, octant, position)
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
        _setVisible(nx, ny)
    end

    local function Compute(octant, position, rangeLimit, xx, top, bottom)

        -- since my grid is one 1 -> grid dimensions
        -- perhaps there is a problem with the calc
  
        for x = xx, rangeLimit, 1 do

            local topY
            if (top.x == 1) then        
                topY = x
            else
                topY = ((x*2-1) * top.y + top.x) // (top.x*2)
                print(topY)
                if BlocksLight(x, topY, octant, position) then
                    if (top:greaterOrEqual(topY*2+1, x*2) and not BlocksLight(x, topY+1, octant, position)) then
                        topY += 1
                    end
                else
                    local ax = x*2 
                    print(ax)
                    if(BlocksLight(x+1, topY+1, octant, position)) then
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
                print(bottomY)
                if(bottom:greaterOrEqual(bottomY*2+1, x*2) and BlocksLight(x, bottomY, octant, position)
                    and not BlocksLight(x, bottomY+1, octant, position)) then
                    bottomY += 1
                end
            end
            
            local wasOpaque = -1 -- 0:false, 1:true, -1:not applicable
            for y = topY, bottomY, -1 do

                if(rangeLimit < 0 or GetDistance(x, y) <= rangeLimit) then
                
                    local isOpaque = BlocksLight(x, y, octant, position)

                    local isVisible
                    if (not symmetry) then
                        isVisible = isOpaque or ((y ~= topY or top:greater(y*4-1, x*4+1)) and (y ~= bottomY or bottom:less(y*4+1, x*4-1)))
                    else
                        --the line ensures that a clear tile is visible only if there's an unobstructed line to its center.
                        -- NOTE: completely symmetrical remove "isOpaque or"
                        isVisible = isOpaque or ((y ~= topY or top:greaterOrEqual(y, x)) and (y ~= bottomY or bottom:lessOrEqual(y, x)))
                    end
                    

                    if(isVisible) then
                        SetVisible(x, y, octant, position) 
                    end

                    if (x ~= rangeLimit) then
                    
                        if(isOpaque) then
                        
                            if(wasOpaque == 0) then
                                local nx = x*2
                                local ny = y*2+1
                                print(nx, ny)
                                if (not symmetry) then
                                    -- NOTE: if you're using full symmetry and want more expansive walls (recommended), comment out the next if
                                    if(BlocksLight(x, y+1, octant, position)) then
                                        nx -= 1 
                                    end
                                end
                                

                                if(top:greater(ny, nx)) then
                                       
                                    if (y == bottomY) then
                                        bottom = slope(ny, nx) 
                                        break
                                    else 
                                        Compute(octant, position, rangeLimit, x+1, top, slope(ny, nx))
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
                                print(nx, ny)
                                if (not symmetry) then
                                    -- NOTE: if you're using full symmetry and want more expansive walls (recommended), comment out the next if
                                    if(BlocksLight(x+1, y+1, octant, position)) then
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
    end

    _setVisible(position.x, position.y)

    for octant = 0, 7, 1 do
        Compute(octant, position, rangeLimit, 1, slope(1, 1), slope(0, 1))
    end
end
