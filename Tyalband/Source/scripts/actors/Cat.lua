class("Cat").extends(Monster)

function Cat:init(theLevel, startPosition)
    Cat.super.init(self, theLevel, startPosition)
    self.name = "Cat"
    self.glyph = "c"
    self.description = "A cute white cat tipped in black. It purrs loudly."
    
    self.combatant = false
end

function Cat:doAction()
    local chanceToMove = 0.20
    local move = math.random() <= chanceToMove
    if (move) then
        local dir = self.level.distanceMapManager:getStep("toPlayerPathMap", self.position)
        if (dir == Vector2.zero()) then
            dir = Vector2.randomCardinal()
        end
        self:move(dir)
        return
    end
    self:wait()
end