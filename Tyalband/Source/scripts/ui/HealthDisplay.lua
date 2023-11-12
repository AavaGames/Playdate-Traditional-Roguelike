local gfx <const> = playdate.graphics

class("HealthDisplay").extends()

function HealthDisplay:init(player)
    self.player = player
    self.playerHealth = player:getComponent(Health)
    self.prevPlayerHP = nil
    self.hadTarget = false

    self.screenManager = screenManager

    -- Border/Health glyphs change depending on status effect
    -- Border is one category (impairment?) and health is another (poison?)

    local function createStatusGlyphTable(border, health, fill)
        return { border = border, health = health, fill = fill }
    end
    self.statusGlyphs = {
        default = createStatusGlyphTable("-", "**", "|"),
        stun = createStatusGlyphTable("!", "**", "!"),
        confusion = createStatusGlyphTable("?", "**", "?"),
    }

    self.font = screenManager.levelFont_8px
    self.drawHeight = math.floor(screenManager.screenDimensions.y * 0.71) -- size of combat viewport

    self:redraw()
end



function HealthDisplay:showMonsterHP(monster)
    self.currentMonster = monster
end

function HealthDisplay:update() end

function HealthDisplay:draw()
    if (self.screenManager.combatView) then
        if (self.screenManager:redrawingScreen()) then
            self:redraw()
        end

        gfx.setColor(self.screenManager.bgColor)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.setFont(self.font.font)

        -- draw player HP on the left
        if (self.prevPlayerHP ~= self.playerHealth.currentHP) then
            self:drawHealthBar(self.playerHealth:percent(), true)
            self.prevPlayerHP = self.playerHealth.currentHP
        end

        -- draw monster HP on the right
        if (self.player.currentTarget ~= nil and self.player.currentTarget:isa(Monster)) then
            local target = self.player.currentTarget
            local targetHealth = target:getComponent(Health)
            if (targetHealth ~= nil) then
                self:drawHealthBar(targetHealth:percent(), false)
                self.hadTarget = true
            end
        elseif (self.hadTarget) then
            self:clearHealthBar(false)
            self.hadTarget = false
        end
    else
        self:redraw()
    end
end

function HealthDisplay:redraw()
    self.prevPlayerHP = nil
end

function HealthDisplay:drawHealthBar(percent, leftSide)
    -- TODO clean up and add status selection

    -- clear area
    local x = leftSide and 0 or self.screenManager.screenDimensions.x - self.font.size.width
    self:clearHealthBar(leftSide)
    -- pick glyphs based on major status
    local glyphs = self.statusGlyphs.default

    -- draw
    local maxGlyphs = self.drawHeight // self.font.size.height
    local hp = percent
    local fillGlyphMax = maxGlyphs - 2
    local healthGlyphPercentAmount = 1 / (maxGlyphs - 2)
    local percent = 0.01

    local txt = table.create(maxGlyphs)
    table.insert(txt, glyphs.border)
    for i = 1, fillGlyphMax, 1 do
        if (hp >= percent) then
            table.insert(txt, 1, glyphs.health)
        else
            table.insert(txt, 1, glyphs.fill)
        end
        percent += healthGlyphPercentAmount
    end
    table.insert(txt, 1, glyphs.border)

    for i = 1, #txt, 1 do
        gfx.drawText(txt[i], x, ((i-1) * self.font.size.height))
    end
end

function HealthDisplay:clearHealthBar(leftSide)
    local x = leftSide and 0 or self.screenManager.screenDimensions.x - self.font.size.width
    gfx.fillRect(x, 0, self.font.size.width, self.drawHeight)
end