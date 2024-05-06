---@class Crystal
---@overload fun(theLevel: Level, startPosition: Vector2): Crystal
Crystal = class("Crystal").extends(Feature) or Crystal

function Crystal:init(theLevel, startPosition)
    Crystal.super.init(self, theLevel, startPosition)
    self.glyph = "#"
    self.name = "Crystal"
    self.description = "A cold perfectly transparent crystal."

    self.collision = true
    self.renderWhenSeen = true

    self.moveCost = 1
end

function Crystal:findWallGlyph()
    -- --[[
    --    1 2 3
    --    4 5 6
    --    7 8 9
    -- ]]
    local neighbors = table.create(9)
    local i = 1
    for x = self.position.x - 1, self.position.x + 1, 1 do
        for y = self.position.y - 1, self.position.y + 1, 1 do
            local tile = self.level:getTile(x, y)
            if (tile ~= nil) then
                if (tile.feature ~= nil and tile.feature.className == self.className) then
                    neighbors[i] = true
                end
            end
            i += 1
        end
    end

    local walls = {
        --   0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
            '#', '─', '│', '┘', '│', '┐', '│', '┤', '─', '─', '└', '┴', '┌', '┬', '├', '┼'
        };

    local index = (neighbors[2] and 1 or 0) +
                (neighbors[4] and 2 or 0) +
                (neighbors[6] and 4 or 0) +
                (neighbors[8] and 8 or 0)
    self.glyph = walls[index + 1];
end