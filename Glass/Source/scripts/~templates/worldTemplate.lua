local gfx <const> = playdate.graphics

class("w").extends()

function w:init(theWorldManager, thePlayer)
    -- do stuff
    self.name = "World"
    self.playerSpawnPosition = { x = 16, y = 53 }
    w.super.init(self, theWorldManager, thePlayer)
end

function w:create()
    -- abstract function to create grid. JSON or generated
end