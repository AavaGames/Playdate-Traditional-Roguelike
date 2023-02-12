local gfx <const> = playdate.graphics

class("Template").extends(Level)

function Template:init(theLevelManager, thePlayer)
    Template.super.init(self, theLevelManager, thePlayer)

    -- do stuff
    self.name = "Level"
    self.FullyLit = false
    self.FullySeen = false
    self.playerSpawnPosition = { x = 16, y = 53 }
    
    Template.super.finishInit(self)
end

function Template:create()
    -- abstract function to create grid. JSON or generated
end