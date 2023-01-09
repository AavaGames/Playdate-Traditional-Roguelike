
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