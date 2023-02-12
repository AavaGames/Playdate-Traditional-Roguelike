local gfx <const> = playdate.graphics

class("Camera").extends()

function Camera:init(target, theLevel, startPosition)
    self.settings = settings
    self.target = target -- any actor, usually player
    self.position = Vector2.zero()
    if (self.target == nil) then
        self.level = theLevel
        self.position = Vector2.copy(startPosition)
    end
    self.bounds, self.move = nil, nil
    self:calculateBounds()
    self:centreOnTarget()
    self:update()
end

function Camera:update()
    if (self.target) then
        -- TODO camera always follow player setting
        if (self.settings.cameraFollowPlayer == true) then
            self.position = Vector2.copy(self.target.position)
        else
            if (self.target.position.x > self.position.x + self.bounds.x) then -- right
                self.position.x = self.target.position.x + self.bounds.x
            elseif (self.target.position.x < self.position.x - self.bounds.x) then -- left
                self.position.x = self.target.position.x - self.bounds.x
            end
            if (self.target.position.y > self.position.y + self.bounds.y) then -- down
                self.position.y = self.target.position.y + self.bounds.y
            elseif (self.target.position.y < self.position.y - self.bounds.y) then -- up
                self.position.y = self.target.position.y - self.bounds.y
            end
        end
    else
        if inputManager:justReleased(playdate.kButtonRight) then
            self.position.x += 1
        end
        if inputManager:justReleased(playdate.kButtonLeft) then
            self.position.x -= 1
        end
        if inputManager:justReleased(playdate.kButtonUp) then
            self.position.y -= 1
        end
        if inputManager:justReleased(playdate.kButtonDown) then
            self.position.y += 1
        end
        self.position = Vector2.clamp(Vector2.one(), self.level.gridDimensions)
    end
end

function Camera:centreOnTarget()
    self.position = Vector2.copy(self.target.position)
end

function Camera:calculateBounds()
    -- the bounds are based on the screen right now but they need to be based on the DRAW
    self.bounds = {
        x = screenManager.viewportGlyphDrawMax.x // 2 - self.target.visionRange,
        y = screenManager.viewportGlyphDrawMax.y // 2 - self.target.visionRange
    }
    self.move = { -- (((self.target.visionRange + 1)  * 2) + 1) add padding to stop flip flop on move
        x = screenManager.viewportGlyphDrawMax.x - self.target.visionRange * 2,
        y = screenManager.viewportGlyphDrawMax.y - self.target.visionRange * 2
    }
    self:centreOnTarget()
end