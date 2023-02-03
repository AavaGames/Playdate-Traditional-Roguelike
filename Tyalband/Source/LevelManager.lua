local gfx <const> = playdate.graphics

class("LevelManager").extends()

function LevelManager:init(player)
    screenManager.levelManager = self
    self.player = player
    self.currentLevel = nil

    self:loadLevel(Dungeon)
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

function LevelManager:loadLevel(level)
    self.player:despawn()
    --insert transition
    self.currentLevel = level(self, self.player)
    screenManager:redrawScreen()
end
