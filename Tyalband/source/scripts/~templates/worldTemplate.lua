local gfx <const> = playdate.graphics

class("W").extends(World)

function W:init(theWorldManager, thePlayer)
    W.super.init(self, theWorldManager, thePlayer)

    -- do stuff
    self.name = "World"
    self.worldIsLit = false
    self.worldIsSeen = false
    self.playerSpawnPosition = { x = 16, y = 53 }
    
    W.super.finishInit(self)
end

function W:create()
    -- abstract function to create grid. JSON or generated
end