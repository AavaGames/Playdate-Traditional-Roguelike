local gfx <const> = playdate.graphics

class("camera").extends()

function camera:init(target, theWorld, x, y)
    self.target = target
    if (self.target == nil) then
        self.world = theWorld
        self.x = x
        self.y = y
    end
end

function camera:update()
    if (self.target) then
        self.x = self.target.x;
        self.y = self.target.y;
    else
        if playdate.buttonJustPressed(playdate.kButtonRight) then
            self.x += 1
        end
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.x -= 1
        end
        if playdate.buttonJustPressed(playdate.kButtonUp) then
            self.y -= 1
        end
        if playdate.buttonJustPressed(playdate.kButtonDown) then
            self.y += 1
        end
        self.x = math.clamp(self.x, 0, self.world.gridDimensions.x-1)
        self.y = math.clamp(self.y, 0, self.world.gridDimensions.y-1)
    end
end