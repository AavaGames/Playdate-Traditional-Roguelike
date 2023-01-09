local gfx <const> = playdate.graphics

class("worldManager").extends()

currentWorld = nil

function worldManager:init(player)
    self.insetAmount = 1
    self.xMaxPercentCutoff = 1
    self.yMaxPercentCutoff = 1
    self.logYMaxPercentCutoff = 0.6
    -- can be used to move viewport around in addition to cutoff
    self.drawOffset = { x = 0, y = 0 }

    self.player = player
    self.currentWorld = nil
    self.worldBorder = border(2, 2, 400-8, 240-8, 4, gfx.kColorBlack)

    self:loadWorld(town)
end

function worldManager:update()
    self.player:update()
    self.currentWorld:update()
end

function worldManager:lateUpdate()
    self.currentWorld:lateUpdate()
end

function worldManager:draw()
    self.currentWorld:draw()
    self.worldBorder:draw()
end

function worldManager:loadWorld(world)
    self.player:despawn()
    --insert transition
    self.currentWorld = world(self, self.player)
end