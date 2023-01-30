class("lightSource").extends(item)

function lightSource:init()
    self.name = "Light"

    self.litRange = 2 -- the range of lit tiles
    self.dimRange = 4 -- the range of dim tiles
end