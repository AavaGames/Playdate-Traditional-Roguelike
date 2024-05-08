
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