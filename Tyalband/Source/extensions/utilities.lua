
utilities = {}

---Creates an empty 2D table
---@param x integer
---@param y integer
---@return table
function table.create2D(x, y)
    local t = table.create(x)
    for i = 1, x do
        t[i] = table.create(y)
    end
    return t
end

--- Seeds math.randomseed using playdate time
---@param maxSize? integer
function utilities.seedUsingTime(maxSize)
    local sec, mill = playdate.epochFromGMTTime(playdate.getTime())
    local seed = sec + mill
    math.randomseed(seed)

    if (maxSize ~= nil) then
        seed = math.random(0, maxSize)
    end

    pDebug:log("Seed: " .. seed)
    math.randomseed(seed)
end