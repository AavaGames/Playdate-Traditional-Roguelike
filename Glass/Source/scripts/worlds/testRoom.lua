local gfx <const> = playdate.graphics

class("testRoom").extends(world)

function testRoom:init(theWorldManager, thePlayer)
    testRoom.super.init(self, theWorldManager, thePlayer) -- calls create

    -- do stuff
    self.name = "Testing Room"
    self.worldIsLit = false
    self.worldIsSeen = false
    self.playerSpawnPosition = { x = self.gridDimensions.x // 2, y = self.gridDimensions.y // 2 }

    testRoom.super.finishInit(self)
end

function testRoom:create()
    -- abstract function to create grid. JSON or generated
    self.gridDimensions = { x = 20, y = 20 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)

        for y = 1, self.gridDimensions.y, 1 do
            self.grid[x][y] = tile(x, y)

            local tile = self.grid[x][y]
            if (tile ~= nil) then
                tile.decoration = ground()
            end
        end
    end

end