class("lightSource").extends(item)

function lightSource:init()
    self.name = "Light"

    self.litRange = 3 -- the range of lit tiles
    self.dimRange = 5 -- the range of dim tiles
end