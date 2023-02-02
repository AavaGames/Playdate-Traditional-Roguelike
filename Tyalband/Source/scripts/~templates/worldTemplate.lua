local gfx <const> = playdate.graphics

class("W").extends(Level)

function W:init(theLevelManager, thePlayer)
    W.super.init(self, theLevelManager, thePlayer)

    -- do stuff
    self.name = "Level"
    self.levelIsLit = false
    self.levelIsSeen = false
    self.playerSpawnPosition = { x = 16, y = 53 }
    
    W.super.finishInit(self)
end

function W:create()
    -- abstract function to create grid. JSON or generated
end