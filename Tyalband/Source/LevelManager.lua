local gfx <const> = playdate.graphics

---@class LevelManager : Object
---@overload fun(player: Player): LevelManager
LevelManager = class("LevelManager").extends() or LevelManager

function LevelManager:init(player)
    screenManager.levelManager = self
    self.player = player
    self.currentLevel = nil

    -- FIRST LEVEL LOADED
    self:loadLevel(Town)
end

function LevelManager:update()
    self.player:update()
    self.currentLevel:update()
end

function LevelManager:lateUpdate()
    self.currentLevel:lateUpdate()
end

function LevelManager:draw()
    self.currentLevel:draw()
end

function LevelManager:loadLevel(level, transition)
    self.player:despawn()
    --insert transition
    if (transition) then
        gfx.clear()
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextAligned("enter oronmaril...", screenManager.screenDimensions.x, screenManager.screenDimensions.y - 16, kTextAlignment.right)
        coroutine.yield()
    end
    --
    self.currentLevel = level(self, self.player)
    screenManager:redrawScreen()
end
