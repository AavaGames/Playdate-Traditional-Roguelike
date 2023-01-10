local gfx <const> = playdate.graphics

class("worldManager").extends()

currentWorld = nil

function worldManager:init(player)
    self.player = player
    self.currentWorld = nil
    self.worldBorder = border(2, 2, 400-8, 240-8, 4, gfx.kColorBlack)

    self.defaultViewport = {
        x = fontSize,
        y = fontSize,
        width = screenDimensions.x - fontSize * 2,
        height = screenDimensions.y - fontSize * 2
    }
    self.viewport = self.defaultViewport

    self:loadWorld(town)
end

function worldManager:update()
    self.player:update()
    self.currentWorld:update()

    if (playdate.buttonJustPressed(playdate.kButtonB)) then
        local view = {
            x = 12,
            y = 12,
            width = screenDimensions.y - 24,
            height = screenDimensions.y - 24
        }
        self:setViewport(view)
    end
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

function worldManager:setViewport(viewport)
    -- IDEA: Coroutine to have smooth transition
    self.viewport = viewport or self.defaultViewport
    print("view", self.viewport.width)
    self.currentWorld.redrawWorld = true
end
