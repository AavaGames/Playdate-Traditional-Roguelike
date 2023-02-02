class("LightSource").extends(Item)

function LightSource:init()
    self.name = "Light"

    self.litRange = 2 -- the range of lit tiles
    self.dimRange = 4 -- the range of dim tiles
end