local gfx <const> = playdate.graphics

class("worldManager").extends()

currentWorld = nil

function worldManager:init(player)
    screenManager.worldManager = self
    self.player = player
    self.currentWorld = nil
    self.worldBorder = border(2, 2, 400-4, 240-4, 4, gfx.kColorBlack)

    self.defaultViewport = {
        x = screenManager.currentWorldFont.size,
        y = screenManager.currentWorldFont.size,
        width = screenManager.screenDimensions.x - screenManager.currentWorldFont.size * 2,
        height = screenManager.screenDimensions.y - screenManager.currentWorldFont.size * 2
    }
    self.viewport = self.defaultViewport

    self:loadWorld(dungeon)
end

function worldManager:update()
    self.player:update()
    self.currentWorld:update()

    if (playdate.buttonJustPressed(playdate.kButtonB)) then
        local view = {
            x = 12,
            y = 12,
            width = screenManager.screenDimensions.y - 24,
            height = screenManager.screenDimensions.y - 24
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
    screenManager:redrawScreen()
end
