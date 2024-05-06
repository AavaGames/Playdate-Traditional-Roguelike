local gfx <const> = playdate.graphics

---@class Dungeon
---@overload fun(theLevelManager: LevelManager, thePlayer: Player): Dungeon
Dungeon = class("Dungeon").extends(Level) or Dungeon

function Dungeon:init(theLevelManager, thePlayer)
    Dungeon.super.init(self, theLevelManager, thePlayer)
    self.name = "Floor 1 (50 feet)"

    self.FullyLit = true

    self.playerSpawnPosition = { x = 18, y = 19 }
    self.playerSpawnPosition = { x = 18, y = 12 }

    self.playerSpawnPosition = { x = 9, y = 8}


    Cat(self, Vector2.new(2, 2)) -- Cat locked away in top left corner

    Zombie(self, Vector2.new(2, 13))
    Zombie(self, Vector2.new(3, 13))

    Zombie(self, Vector2.new(2, 14))
    Zombie(self, Vector2.new(3, 14))

    --Cat(self, Vector2.new(23, 2))

    self.grid[2][2].glow = true
    self.grid[2][3].glow = true
    self.grid[3][2].glow = true
    self.grid[3][3].glow = true

    self.grid[9][18].glow = true
    self.grid[9][19].glow = true
    self.grid[10][18].glow = true
    self.grid[10][19].glow = true

    Dungeon.super.finishInit(self)
end

function Dungeon:create()
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = crystal, 3 = ground, 4 = grass
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
                elseif type == 2 then
                    tile.feature = Crystal(self, Vector2.new(x,y))
                elseif type == 4 then
                    tile.feature = Grass(self, Vector2.new(x,y))
                end
            end
        end
    end
end