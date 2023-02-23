class("Zombie").extends(Monster)

function Zombie:init(theLevel, startPosition)
    Zombie.super.init(self, theLevel, startPosition)
    self.name = "Zombie"
    self.glyph = "z"
    self.description = "A walking corpse."

    self.moveSpeed = 2
end

function Zombie:doAction()
    local chanceToMove = 1
    local move = math.random() <= chanceToMove
    if (move) then
        local dir = self.level.distanceMapManager:getStep("toPlayerPathMap", self.position)
        if (dir == Vector2.zero()) then
            dir = Vector2.randomCardinal()
        end
        if not self:move(dir) then
            self:wait()
        end
        return
    end
    self:wait()
end