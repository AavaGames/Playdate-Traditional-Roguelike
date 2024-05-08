local gfx <const> = playdate.graphics

-- ---@class Template : Level
-- ---@overload fun(theLevelManager: LevelManager, thePlayer: Player): Template
-- Template = class("Template").extends("Level") or Template


function Template:init(theLevelManager, thePlayer)
    Template.super.init(self, theLevelManager, thePlayer)

    -- do stuff
    self.name = "Level"
    self.FullyLit = false
    self.FullySeen = false
    self.playerSpawnPosition = { x = 16, y = 53 }
    
    Template.super.finishInit(self)
end

-- Creates the level, called in super.init
function Template:create()
    -- abstract function to create grid. JSON or generated

    self.gridDimensions = { x = 30, y = 30 }

    self.grid = table.create(self.gridDimensions.x)
    for x = 1, self.gridDimensions.x, 1 do
        self.grid[x] = table.create(self.gridDimensions.y)

        for y = 1, self.gridDimensions.y, 1 do
            -- tile
        end
    end
end