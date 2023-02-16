class("Cat").extends(Monster)

function Cat:init(theLevel, startPosition)
    Cat.super.init(self, theLevel, startPosition)
    self.name = "Cat"
    self.glyph = "c"
    self.description = "A cute white cat tipped in black. It purrs loudly."
end

function Cat:round()
    Cat.super.round(self)
    local chanceToMove = 0.20
    local move = math.random() <= chanceToMove
    if (move) then
        local dir = self.level.distanceMapManager:getStep("toPlayerPathMap", self.position)
        if (dir == Vector2.zero()) then
            self:move(Vector2.randomCardinal())
        end
        self:move(dir)
    end
end

function Cat:interact(actor)
    if (actor:isa(Player)) then
        gameManager.logManager:addToRound(self.description)
    end
end