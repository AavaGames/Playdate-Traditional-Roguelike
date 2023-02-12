local gfx <const> = playdate.graphics

class("TestRoom").extends(Level)

function TestRoom:init(theLevelManager, thePlayer)
    TestRoom.super.init(self, theLevelManager, thePlayer) -- calls create

    -- do stuff
    self.name = "Testing Room"
    self.FullyLit = true
    self.FullySeen = false
    self.playerSpawnPosition = { x = self.gridDimensions.x // 2, y = self.gridDimensions.y // 2 }

    local a = Animal(self, Vector2.new(self.playerSpawnPosition.x + 5 , self.playerSpawnPosition.y - 5))
    Cat(self, Vector2.new(self.playerSpawnPosition.x - 5 , self.playerSpawnPosition.y - 5))

    TestRoom.super.finishInit(self)

    self.distanceMapManager:addSource("toPlayerPathMap", a, 0)
end

function TestRoom:create()
    -- abstract function to create grid. JSON or generated
    self.gridDimensions = { x = 60, y = 30 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)

        for y = 1, self.gridDimensions.y, 1 do
            self.grid[x][y] = Tile(x, y)

            local tile = self.grid[x][y]
            if (tile ~= nil) then
                tile.feature.glyph = "#"
                -- change feature?
            end
        end
    end

end