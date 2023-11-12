class("Monster").extends(Actor)

local SensitivityType <const> = enum.new({ "None", "Normal", "Enhanced", "Incredible" })
local IntelligenceType <const> = enum.new({ "Stupid", "Average", "Intelligent" })

local MovementBehaviorType <const> = enum.new({ "Stupid", "Average", "Intelligent" })
local AllyBehaviorType <const> = enum.new({ "Stupid", "Average", "Intelligent" })
local CombatBehaviorType <const> = enum.new({ "Aggro", "Defensive", "Intelligent" })

function Monster:init(theLevel, startPosition)
    Monster.super.init(self, theLevel, startPosition)

    self.dead = false -- TODO: think this through more

    self.race = "" -- The base race it belongs to
    self.type = "" -- The type or name of the monster
    self.packType = ""

    self.visionType = nil
    self.visionRange = 6 -- update through file

    self.SensitivityType = SensitivityType
    self.hearingSensitivity = SensitivityType.Normal
    self.smellSensitivity = SensitivityType.Normal

    self.averageHP = 1

    self.light = 0 -- bright light is 50% of this value, can be negative

    self.sleepiness = 0 -- 0-100 chance that the creature is sleeping on spawn

    self.depth = 1 -- the usual depth of the creature
    self.rarity = 100 -- 0-100 % rarity of creature
    self.experience = 1 -- exp * depth / player level

    --challenge rating?

    self.IntelligenceType = IntelligenceType
    self.intelligence = IntelligenceType.Average

    self.blow = nil 
    --[[
        MonsterBlow.lua
            Name, Type, Effect, Damage
    ]]

    self.caster = false -- add Components if caster (spellbook and/or innate)

    self.MovementBehaviorType = MovementBehaviorType
    self.CombatBehaviorType = CombatBehaviorType

    self.movementBehavior = nil
    self.allyBehavior = nil
    self.combatBehavior = nil

    self.fearChance = 10 -- 0-100 %

    self.dropType = nil
    self.allies = nil
    self.combatant = true

    -- Components

    self.health:setMaxHP(10)
    self.health.onDeath = function() self:death() end
end

function Monster:interact()
    if (self.currentTarget:isa(Player)) then
        --self:attack()
        if (self.combatant) then
            gameManager.logManager:addToRound("The " .. self.name .. " attacks " .. self.currentTarget.name .. ".")
            self.currentTarget.health:damage(1)
        else
            gameManager.logManager:addToRound("The " .. self.name .. " bumps into " .. self.currentTarget.name .. ".")
        end

    -- none possible?
    elseif (self.currentTarget:isa(Monster)) then
    elseif (self.currentTarget:isa(Feature)) then
    elseif (self.currentTarget:isa(NPC)) then
    end

end

function Monster:attack()
    Monster.super.attack(self)

end

function Monster:death()
    gameManager.logManager:addToRound(self.name .. " dies.")
    self.dead = true -- stay in list but stop updating
    self.tile:exit(self) -- leave tile and vanish
end

function Monster:doAction()

    -- CHANGE TO SENSE RANGE?
    if (Vector2.distance(self.position, self.level.player.position) <= self.visionRange) then
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