local gfx <const> = playdate.graphics

---@class Town : Level
---@overload fun(theLevelManager: LevelManager, thePlayer: Player): Town
Town = class("Town").extends("Level") or Town


function Town:init(theLevelManager, thePlayer)
    Town.super.init(self, theLevelManager, thePlayer)
    self.name = "Base Camp"
    self.FullyLit = true
    self.FullySeen = true

    self.playerSpawnPosition = { x = 16, y = 53 }

    Cat(self, Vector2.new(6, 43))
    Animal(self, Vector2.new(7, 43))

    local downPos = Vector2.new(16, 1)
    self.grid[downPos.x][downPos.y].feature = Stairs(self, downPos, true, Prototype)

    Town.super.finishInit(self)
end

function Town:create()
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = crystal, 3 = ground, 4 = grass
    local townFile = playdate.file.open("assets/maps/town.json")
    local townJson = json.decodeFile(townFile)
    local townArray = townJson.layers[1].data
    self.gridDimensions = { x = townJson.width, y = townJson.height }

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
            local type = townArray[index]

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