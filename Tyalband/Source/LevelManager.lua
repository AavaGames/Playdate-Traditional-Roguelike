local gfx <const> = playdate.graphics

class("LevelManager").extends()

function LevelManager:init(player)
    screenManager.levelManager = self
    self.player = player
    self.currentLevel = nil

    self.defaultViewport = {
        x = screenManager.currentLevelFont.size,
        y = screenManager.currentLevelFont.size,
        width = screenManager.screenDimensions.x - screenManager.currentLevelFont.size * 2,
        height = screenManager.screenDimensions.y - screenManager.currentLevelFont.size * 2
    }
    -- self.defaultViewport = {
    --         x = 0,
    --         y = 0,
    --         width = screenManager.screenDimensions.x;
    --         height = screenManager.screenDimensions.y;
    --     }
    self.viewport = self.defaultViewport

    self:loadLevel(Dungeon)
end

function LevelManager:update()
    self.player:update()
    self.currentLevel:update()

    -- TODO add to debug menu
    -- if (inputManager:HeldLong(playdate.kButtonB)) then
    --     local view = {
    --         x = 12,
    --         y = 12,
    --         width = screenManager.screenDimensions.y - 24,
    --         height = screenManager.screenDimensions.y - 24
    --     }
    --     self:setViewport(view)
    -- end
end

function LevelManager:lateUpdate()
    self.currentLevel:lateUpdate()
end

function LevelManager:draw()
    self.currentLevel:draw()
end

function LevelManager:loadLevel(level)
    self.player:despawn()
    --insert transition
    self.currentLevel = level(self, self.player)
end

function LevelManager:setViewport(viewport)
    -- IDEA: Coroutine to have smooth transition
    self.viewport = viewport or self.defaultViewport
    screenManager:redrawScreen()
end
