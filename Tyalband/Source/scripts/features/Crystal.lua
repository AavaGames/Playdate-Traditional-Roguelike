class("Crystal").extends(Feature)

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
    -- make array of bool of wall neighbors

    local neighbors = table.create(9)
    local i = 1
    for x = self.position.x - 1, self.position.x + 1, 1 do
        for y = self.position.y - 1, self.position.y + 1, 1 do
            local tile = self.level:getTile(x, y)
            if (tile ~= nil) then
                if (tile.feature ~= nil and tile.feature.className == self.className) then
                    neighbors[i] = tile.feature
                end
            end
            i += 1
        end
    end

    --[[
       1 2 3
       4 5 6
       7 8 9
    ]]

    if (neighbors[4] and neighbors[6]) then
        self.glyph = "│"
    elseif (neighbors[2] and neighbors[8]) then
        self.glyph = "─"
    else
        --self.glyph = ""
    end
end