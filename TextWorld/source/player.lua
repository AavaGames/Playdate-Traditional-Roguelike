import "global"
import "actor"

class("player").extends(actor)

function player:init(x, y)
    player.super.init(self, x, y)
    self.char = "O"
    self.name = "Player"

end

function player:update()
    player.super.update(self)

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        self:move(1, 0)
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        self:move(-1, 0)
    end
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        self:move(0, -1)
    end
    if playdate.buttonJustPressed(playdate.kButtonDown) then
        self:move(0, 1)
    end
end