function ComputeShadow(origin, world, is_blocking, mark_visible)

    local mark_visible = function (x, y) -- set visible
        if (math.isClamped(x, 1, world.gridDimensions.x) or math.isClamped(y, 1, world.gridDimensions.y)) then
            return false
        end
        local tile = world.grid[x][y]
        if (tile ~= nil) then
            tile.inView = true

            tile.currentVisibilityState = tile.visibilityState.lit
            tile:addLightLevel(2, world.player.equipped.lightSource)
            tile.seen = true
        end
    end

    local is_blocking = function (x, y)
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

    mark_visible(origin.x, origin.y)
    for i = 1, 4, 1 do
        local quadrant = Quadrant(i, origin)

        local function reveal(tile)
            local quad = quadrant:transform(tile)
            mark_visible(quad[1], quad[2])
        end

        local function is_wall(tile) 
            if tile == nil then
                return false
            end
            local quad = quadrant:transform(tile)
            return is_blocking(quad[1], quad[2])
        end

        local function is_floor(tile)
            if tile == nil then
                return false
            end
            local quad = quadrant:transform(tile)

            return not is_blocking(quad[1], quad[2])
        end
        
        local curRow = 0

        local function scan(row)
            curRow += 1
            if (curRow > 6) then
                return
            end

            local prev_tile = nil
            
            local tiles = row:tiles()
            for index, tile in ipairs(tiles) do

                if is_wall(tile) or is_symmetric(row, tile) then
                    reveal(tile)
                end
                -- nil check on prev
                if is_wall(prev_tile) and is_floor(tile) then
                    row.start_slope = slope(tile)
                end
                if is_floor(prev_tile) and is_wall(tile) then
                    local next_row = row:next()
                    next_row.end_slope = slope(tile)
                    scan(next_row)
                end
                prev_tile = tile
            end
            if is_floor(prev_tile) then
                scan(row:next())
            end
        end
        
        local first_row = Row(1, -1, 1)
        scan(first_row)
    end
end

class("Quadrant").extends()

function Quadrant:init(cardinal, origin)
    self.north = 1
    self.east  = 2
    self.south = 3
    self.west  = 4

    self.cardinal = cardinal
    self.ox = origin.x
    self.oy = origin.y
end
function Quadrant:transform(tile)

    local row = tile[1]
    local col = tile[2]

    if self.cardinal == self.north then
        return {self.ox + col, self.oy - row}
    end
    if self.cardinal == self.south then
        return {self.ox + col, self.oy + row}
    end
    if self.cardinal == self.east then
        return {self.ox + row, self.oy + col}
    end
    if self.cardinal == self.west then
        return {self.ox - row, self.oy + col}
    end
end

class("Row").extends()

function Row:init(depth, start_slope, end_slope) 
    self.depth = depth
    self.start_slope = start_slope
    self.end_slope = end_slope
end

function Row:tiles()
    local min_col = round_ties_up(self.depth * self.start_slope)
    local max_col = round_ties_down(self.depth * self.end_slope)
    local tiles = {}
    for col = min_col, max_col + 1, 1 do
        table.insert(tiles, {self.depth, col})
    end
    return tiles
end
function Row:next()
    return Row(
        self.depth + 1,
        self.start_slope,
        self.end_slope)
end

function slope(tile)
    local row_depth = tile[1]
    local col = tile[2]

    return 2 * col - 1 // 2 * row_depth
end

function is_symmetric(row, tile)
    local col = tile[2]
    return (col >= row.depth * row.start_slope and col <= row.depth * row.end_slope)
end

function round_ties_up(n)
    return math.floor(n + 0.5)
end

function round_ties_down(n)
    return math.ceil(n - 0.5)
end
