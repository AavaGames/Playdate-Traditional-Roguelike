local gfx <const> = playdate.graphics

class("HealthDisplay").extends()

function HealthDisplay:init(player)
    self.player = player

    -- Glyphs change depending on status effect
    self.borderGlyph = "~"
    self.healthGlyph = "*"
    self.fillGlyph = "|"

    self.font = screenManager.logFont_6px
end

function HealthDisplay:showMonsterHP(monster)

end

function HealthDisplay:draw()
    -- the two glyphs (border & health) are changed depending on status effect 

    -- draw player HP on the left

    -- draw monster HP on the right
end