local gfx <const> = playdate.graphics

class("Dungeon").extends(Level)

function Dungeon:init(theLevelManager, thePlayer)
    Dungeon.super.init(self, theLevelManager, thePlayer)
    self.name = "Floor 1 (50 feet)"

    self.playerSpawnPosition = { x = 18, y = 19 }
    --self.playerSpawnPosition = { x = 32, y = 16 }
    Animal(self, Vector2.new(2, 13))

    self.grid[9][18].glow = true
    self.grid[9][19].glow = true
    self.grid[10][18].glow = true
    self.grid[10][19].glow = true

    Dungeon.super.finishInit(self)
end

function Dungeon:create()
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ?, 3 = ?, 4 = grass
    local dungeonFile = playdate.file.open("assets/maps/dungeon.json")
    local dungeonJson = json.decodeFile(dungeonFile)
    local dungeonArray = dungeonJson.layers[1].data
    self.gridDimensions = { x = dungeonJson.width, y = dungeonJson.height }
    
    -- init table
    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)
    end

    -- populate map
    for x = 1, self.gridDimensions.x, 1 do
        for y = 1, self.gridDimensions.y, 1 do
            local width = self.gridDimensions.x
            local index = x + width * (y-1)
            local type = dungeonArray[index]

            if (type > 0) then
                self.grid[x][y] = Tile(x, y)
            else
                self.grid[x][y] = nil
            end
    
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                if type == 1 then
                    tile.feature = Wall(self, Vector2.new(x,y))
                    tile.blocksLight = true
                end
            end
        end
    end
end