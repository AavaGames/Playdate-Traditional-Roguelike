local gfx <const> = playdate.graphics

class("HealthDisplay").extends()

function HealthDisplay:init(player)
    self.player = player

    -- Border/Health glyphs change depending on status effect
    -- Border is one category (impairment?) and health is another (poison?)
    self.borderGlyph = "~"
    self.healthGlyph = "*"
    self.fillGlyph = "|"

    self.font = screenManager.levelFont_8px
end

function HealthDisplay:showMonsterHP(monster)
    self.currentMonster = monster
end

function HealthDisplay:draw()
    -- the two glyphs (border & health) are changed depending on status effect 

    -- draw player HP on the left

    -- draw monster HP on the right

    self.currentMonster = nil -- show only when hitting? or stop after not seen or mon death
end