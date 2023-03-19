local gfx <const> = playdate.graphics

class("Prototype").extends(Level)

local SPRITE_SIZE <const> = 8 -- 8x8 

function Prototype:init(theLevelManager, thePlayer)
    Prototype.super.init(self, theLevelManager, thePlayer) -- create call here
    self.name = "Floor 1 (50 feet)"

    self.FullyLit = true

    -- self.grid[2][2].glow = true
    -- self.grid[2][3].glow = true
    -- self.grid[3][2].glow = true
    -- self.grid[3][3].glow = true

    -- self.grid[9][18].glow = true
    -- self.grid[9][19].glow = true
    -- self.grid[10][18].glow = true
    -- self.grid[10][19].glow = true

    Prototype.super.finishInit(self)
end

function Prototype:create()
    -- var tile = gridArray[y * width + x]
    -- 0 = empty, 1 = wall, 2 = crystal, 3 = ground, 4 = grass
    local file = playdate.file.open("assets/maps/prototype.json")
    local json = json.decodeFile(file)
    local gridArray = json.layers[1].data
    self.gridDimensions = { x = json.width, y = json.height }

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
            local type = gridArray[index]

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

    -- Object placement
    --- These are BOTTOM-LEFT aligned, requiring only the X axis to be added to for lua table conversion

    local objects = json.layers[2].objects
    for index, obj in ipairs(objects) do

        --    Zombie(self, Vector2.new(3, 14))
        if (obj.name == "SpawnPosition") then
            self.playerSpawnPosition = { x = math.round(obj.x / SPRITE_SIZE) + 1, y = math.round(obj.y / SPRITE_SIZE) }
        elseif (obj.name == "UpStairs") then
            -- place up stairs
        elseif (obj.name == "UpStairs") then

        elseif (obj.name == "Z") then
            Zombie(self, Vector2.new(math.round(obj.x / SPRITE_SIZE) + 1, math.round(obj.y / SPRITE_SIZE)))
        elseif (obj.name == "K") then
            Animal(self, Vector2.new(math.round(obj.x / SPRITE_SIZE) + 1, math.round(obj.y / SPRITE_SIZE))) -- random moving placeholder

        end

    end
end