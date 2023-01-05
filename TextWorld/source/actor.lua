import "global"
import "entity"
import "world"

class("actor").extends(entity)

function actor:init(x, y)
    self.char = "a"
    self.name = "Actor"
    self.x = x
    self.y = y
    self.updated = false

    actorGrid[self.x][self.y] = self -- TODO: can spawn on top of another actor overwriting their pos
end

function actor:update()
    self.updated = true
end

function actor:setLocation(x, y)
    x = clamp(x, 0, worldDimension.x - 1)
    y = clamp(y, 0, worldDimension.y - 1)
    if x ~= self.x or y ~= self.y then
        if actorGrid[x][y] == nil then
            actorGrid[self.x][self.y] = nil -- leave old pos
            self.x = x
            self.y = y
            actorGrid[self.x][self.y] = self -- set new pos
    
            --print("new ", x, y)
        end
    end
end

function actor:move(x, y)
    -- add movement
    self:setLocation(self.x + x, self.y + y)
end