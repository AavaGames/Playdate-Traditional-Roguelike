class("animal").extends(actor)

function animal:init(theWorld, x, y)
    animal.super.init(self, theWorld, x, y)
    self.name = "Animal"

    local function randomMove()
        self:move(math.random(-1,1), math.random(-1,1))
        playdate.timer.performAfterDelay(math.random(1000, 3000), randomMove)
    end
    playdate.timer.performAfterDelay(math.random(1000, 3000), randomMove)
end

function animal:update()
    animal.super.update(self)
end