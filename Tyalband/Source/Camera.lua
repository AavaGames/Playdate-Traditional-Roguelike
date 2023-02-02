local gfx <const> = playdate.graphics

class("Camera").extends()

function Camera:init(target, theLevel, startPosition)
    self.target = target
    self.position = Vector2.zero()
    if (self.target == nil) then
        self.level = theLevel
        self.position = startPosition
    end
    self:update()
end

function Camera:update()
    if (self.target) then
        self.position = self.target.position
    else
        if InputManager.JustReleased(playdate.kButtonRight) then
            self.position.x += 1
        end
        if InputManager.JustReleased(playdate.kButtonLeft) then
            self.position.x -= 1
        end
        if InputManager.JustReleased(playdate.kButtonUp) then
            self.position.y -= 1
        end
        if InputManager.JustReleased(playdate.kButtonDown) then
            self.position.y += 1
        end
        self.position = Vector2.clamp(Vector2.one(), self.level.gridDimensions)
    end
end