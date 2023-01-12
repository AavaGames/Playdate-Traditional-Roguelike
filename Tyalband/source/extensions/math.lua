function math.round(value)
    return math.floor(value+0.5)
end

function math.clamp(value, min, max)
    if value < min then
        value = min
    elseif value > max then
        value = max
    end
    return value
end

function math.ring(a, min, max)
    if min > max then
        min, max = max, min
    end

    return min + (a-min)%(max-min)
end

function math.ring_int(a, min, max)
    return dm.math.ring(a, min, max+1)
end

function math.approach(value, target, step)
    if value==target then
        return value, true
    end

    local d = target-value
    if d>0 then
        value = value + step
        if value >= target then
            return target, true
        else
            return value, false
        end
    elseif d<0 then
        value = value - step
        if value <= target then
            return target, true
        else
            return value, false
        end
    else
        return value, true
    end
end

function math.lerp(theStart, theEnd, time)
    return theStart * (1.0 - time) + (theEnd * time);
end

function math.findAllCirclePos(xCenter, yCenter, radius)
    local positions = {} --table.create(radius*radius)
    for x = xCenter - radius, xCenter, 1 do
        for y = yCenter - radius, yCenter, 1 do
            if ((x - xCenter)*(x - xCenter) + (y - yCenter)*(y - yCenter) <= radius*radius) then
                local xSym = xCenter - (x - xCenter);
                local ySym = yCenter - (y - yCenter);
                -- (x, y), (x, ySym), (xSym , y), (xSym, ySym) are in the circle

                table.insert(positions, {x, y})
                table.insert(positions, {x, ySym})
                table.insert(positions, {xSym, y})
                table.insert(positions, {xSym, ySym})
            end
        end
    end
    return positions
end