import "global"
import "actor"

class("player").extends(actor)

function player:init(x, y)
    player.super.init(self, x, y)
    self.char = "O"
    self.name = "Player"

    self.moveDir = { x = 0, y = 0 }
    self.moveSpeed = 5
    self.canMove = true;
end

function player:update()
    player.super.update(self)

    self.moveDir = { x = 0, y = 0 }
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        self.moveDir.x += 1
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.moveDir.x -= 1
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.moveDir.y -= 1
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.moveDir.y += 1
    end

    if (self.canMove) then
        if (self.moveDir.x ~= 0 or self.moveDir.y ~= 0) then
            self:move(self.moveDir.x, self.moveDir.y)
            self.canMove = false

            playdate.timer.performAfterDelay( 1000 / self.moveSpeed, function() self.canMove = true end)
        end
    end
end