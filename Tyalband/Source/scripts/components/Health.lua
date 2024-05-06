---@class Health
---@overload fun(maxHP: integer): Health
Health = class("Health").extends(Component) or Health

function Health:init(maxHP)
    Health.super.init(self)
    self.dead = false

    -- negative value for death (-0.2 = death at current >= -20% maxHp)
    self.deathThreshold = 0
    self.onDeath = function () end

    self.maxHP = maxHP or 1
    self.currentHP = self.maxHP
end

-- gets health percent to nearest 2 decimal places (0.55 = 55%). Can overcap 100% and go into negatives
function Health:percent()
    return math.round((self.currentHP / self.maxHP) * 100) / 100
end

-- returns bool whether current HP is higher than the percent of max 
-- @param percent float percentage (0.5 = 50%)
function Health:above(percent)
    return self.currentHP > self.maxHP * percent
end

-- returns bool whether current HP is lower than the percent of max
-- @param percent float percentage (0.5 = 50%)
function Health:below(percent)
    return self.currentHP < self.maxHP * percent
end

function Health:belowOrEqual(percent)
    return self.currentHP <= self.maxHP * percent
end

function Health:damage(amount)
    self.currentHP -= amount
    if (self:belowOrEqual(self.maxHP * self.deathThreshold)) then
        self.dead = true
        self.onDeath()
    end
end

-- accepts a negative float value and checks for death
function Health:setDeathThreshold(percent)
    if (percent < 0) then
        self.deathThreshold = percent
        self:damage(0)
    end
end

function Health:setMaxHP(value)
    self.maxHP = value
    self.currentHP = self.maxHP
end