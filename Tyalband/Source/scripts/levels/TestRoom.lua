local gfx <const> = playdate.graphics

---@class TestRoom
---@overload fun(theLevelManager: LevelManager, thePlayer: Player): TestRoom
TestRoom = class("TestRoom").extends(Level) or TestRoom

function TestRoom:init(theLevelManager, thePlayer)
    TestRoom.super.init(self, theLevelManager, thePlayer) -- calls create

    -- do stuff
    self.name = "Testing Room"
    self.FullyLit = true
    self.FullySeen = false
    self.playerSpawnPosition = { x = self.gridDimensions.x // 2, y = self.gridDimensions.y // 2 }

    --local a = Animal(self, Vector2.new(self.playerSpawnPosition.x + 5 , self.playerSpawnPosition.y - 5))
    --self.distanceMapManager:addSource("toPlayerPathMap", a, 0)
    --Cat(self, Vector2.new(self.playerSpawnPosition.x - 5 , self.playerSpawnPosition.y - 5))

    for i = 1, 50, 1 do
        Zombie(self, Vector2.new(self.playerSpawnPosition.x + 10, self.playerSpawnPosition.y + 4))
    end

    TestRoom.super.finishInit(self)

end

function TestRoom:create()
    -- abstract function to create grid. JSON or generated
    self.gridDimensions = { x = 30, y = 30 }

    self.playerSpawnPosition = { x = self.gridDimensions.x // 2, y = self.gridDimensions.y // 2 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)

        for y = 1, self.gridDimensions.y, 1 do
            self.grid[x][y] = Tile(x, y)

            local tile = self.grid[x][y]
            if (tile ~= nil) then
                --tile.feature.glyph = "#"
                -- change feature?
            end

            --Create wall and corridor
            if (x == self.playerSpawnPosition.x + 8 and (y ~= self.playerSpawnPosition.y)) then
                tile.feature = Crystal(self, Vector2.new(x, y))
            end

            if (x > self.playerSpawnPosition.x + 2 and x < self.playerSpawnPosition.x + 8) then
                if (y == self.playerSpawnPosition.y + 1 or y == self.playerSpawnPosition.y - 1) then
                    tile.feature = Crystal(self, Vector2.new(x, y))
                end
            end
        end
    end

end