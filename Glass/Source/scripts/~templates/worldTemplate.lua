local gfx <const> = playdate.graphics

class("w").extends(world)

function w:init(theWorldManager, thePlayer)
    w.super.init(self, theWorldManager, thePlayer)

    -- do stuff
    self.name = "World"
    self.worldIsLit = false
    self.worldIsSeen = false
    self.playerSpawnPosition = { x = 16, y = 53 }
    
    w.super.finishInit(self)
end

function w:create()
    -- abstract function to create grid. JSON or generated
end