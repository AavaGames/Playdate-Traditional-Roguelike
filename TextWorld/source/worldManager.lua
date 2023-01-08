import "global"
import "world"

local gfx <const> = playdate.graphics

class("worldManager").extends()

currentWorld = nil

function worldManager:init()
    self.insetAmount = 1
    self.xMaxPercentCutoff = 1
    self.yMaxPercentCutoff = 1
    self.logYMaxPercentCutoff = 0.6
    -- can be used to move viewport around in addition to cutoff
    self.drawOffset = { x = 0, y = 0 }

    currentWorld = world(self)

    self.worldBorder = border(2, 2, 400-8, 240-8, 4, gfx.kColorBlack)
end

function worldManager:update()
    currentWorld:update()
end

function worldManager:draw()
    currentWorld:draw()
    self.worldBorder:draw()
end