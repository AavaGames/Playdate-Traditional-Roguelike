local gfx <const> = playdate.graphics

class("WorldManager").extends()

function WorldManager:init(player)
    screenManager.worldManager = self
    self.player = player
    self.currentWorld = nil

    self.defaultViewport = {
        x = screenManager.currentWorldFont.size,
        y = screenManager.currentWorldFont.size,
        width = screenManager.screenDimensions.x - screenManager.currentWorldFont.size * 2,
        height = screenManager.screenDimensions.y - screenManager.currentWorldFont.size * 2
    }
    -- self.defaultViewport = {
    --         x = 0,
    --         y = 0,
    --         width = screenManager.screenDimensions.x;
    --         height = screenManager.screenDimensions.y;
    --     }
    self.viewport = self.defaultViewport

    self:loadWorld(Dungeon)
end

function WorldManager:update()
    self.player:update()
    self.currentWorld:update()

    if (inputManager:HeldLong(playdate.kButtonB)) then
        local view = {
            x = 12,
            y = 12,
            width = screenManager.screenDimensions.y - 24,
            height = screenManager.screenDimensions.y - 24
        }
        self:setViewport(view)
    end

end

function WorldManager:lateUpdate()
    self.currentWorld:lateUpdate()
end

function WorldManager:draw()
    self.currentWorld:draw()
end

function WorldManager:loadWorld(world)
    self.player:despawn()
    --insert transition
    self.currentWorld = world(self, self.player)
end

function WorldManager:setViewport(viewport)
    -- IDEA: Coroutine to have smooth transition
    self.viewport = viewport or self.defaultViewport
    screenManager:redrawScreen()
end
