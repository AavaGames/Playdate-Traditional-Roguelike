class("Health").extends(Component)

function Health:init(maxHP)
    Health.super.init(self)
    self.dead = false

    -- negative value for death (-0.2 = death at current >= -20% maxHp)
    self.deathThreshold = 0
    self.onDeath = function () end

    self.maxHP = maxHP or 1
    self.currentHP = self.maxHP
end

-- returns bool whether current HP is higher than the percent of max
function Health:above(percent)
    return self.currentHP > self.maxHP * percent
end

-- returns bool whether current HP is lower than the percent of max
function Health:below(percent)
    return self.currentHP < self.maxHP * percent
end

function Health:damage(amount)
    self.currentHP -= amount
    if (self:below(self.maxHP * self.deathThreshold)) then
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