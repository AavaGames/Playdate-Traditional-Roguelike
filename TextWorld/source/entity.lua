import "global"

local gfx <const> = playdate.graphics

class("entity").extends()

local chars = {"v", "W", "M"}

function entity:init()
    --self.char = chars[math.random(3)]
    self.char = "v"
    self.name = "Grass"
end