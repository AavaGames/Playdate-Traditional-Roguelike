local gfx <const> = playdate.graphics

class("town").extends(world)

function town:init(theWorldManager, thePlayer)
    town.super.init(self, theWorldManager, thePlayer)
    self.name = "Base Camp"
    self.worldIsLit = true
    self.worldIsSeen = true
    self.playerSpawnPosition = { x = 16, y = 53 }

    animal(self, Vector2.new(6, 43))
    animal(self, Vector2.new(7, 43))

    town.super.finishInit(self)
end

function town:create()
    -- var tile = array[y * width + x]
    -- 0 = empty, 1 = wall, 2 = ?, 3 = ?, 4 = grass
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
                self.grid[x][y] = tile(x, y)
            else
                self.grid[x][y] = nil
            end
    
            local tile = self.grid[x][y]
            if (tile ~= nil) then
                if type == 1 then
                    wall(self, Vector2.new(x,y))
                elseif type == 3 then
                    --tile.decoration = ground()
                elseif type == 4 then
                    tile.decoration = grass()
                end
            end
        end
    end
end