local gfx <const> = playdate.graphics

class("screenManager").extends()

function screenManager:init()
    self.fps = false
    self.profiler = true
    self.targetFPS = 30
    
    self.screenDimensions = {
        x = 400,
        y = 240
    }

    self.worldFont_8px = { font = gfx.font.new('assets/fonts/IBM/IBM_EGA_8x8'), size = 8 }
    self.worldFont_10px = { font = gfx.font.new('assets/fonts/Rainbow100_re_40'), size = 10 }
    self.worldFont_16px = { font = gfx.font.new('assets/fonts/IBM/IBM_EGA_8x8_2x'), size = 16 }

    self.logFont_6px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/DOS/dos-jpn12-6x12",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/DOS/dos-jpn12-6x12", -- TODO make bold
    }), size = 6, lineCount = 5 }
    self.logFont_8px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/CompaqThin_8x16",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Nix8810_M15",
    }), size = 8, lineCount = 4 }
    self.logFont_12px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/Portfolio_6x8_2x",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Portfolio_6x8_2x", -- TODO make bold
    }), size = 12, lineCount = 4 }

    self.currentWorldFont, self.currentLogFont = nil, nil

    -- Maxmimum characters that can fit on the screen
    self.gridScreenMax = { x = 0, y = 0 }

    -- lit, dim but seen, unseen but known
    self.worldGlyphs = {} -- alloc an estimate?
    self.worldGlyphs_faded = {}
    self.drawnGlyphs = {}
    self:resetDrawnGlyphs()

    -- change viewports states this way? can use something similar for font sizes
    self.screenState = {
        full = function()
            
        end,
        log = function()
            
        end,
        square = function()
        
        end }
    self.currentScreenState = self.screenState.full

    self.defaultDrawMode = playdate.graphics.kDrawModeNXOR -- change to color

    playdate.display.setRefreshRate(self.targetFPS)

    self.bgColor = gfx.kColorBlack

    self.worldManager, self.logManager = nil, nil
    self._redrawScreen = true

    self:setWorldFont("16px")
    self:setLogFont("8px")
end

function screenManager:setWorldColor(color)
    self.bgColor = color
    gfx.setBackgroundColor(self.bgColor)
    self._redrawScreen = true
end

function screenManager:update() end
function screenManager:lateUpdate() end

function screenManager:draw()
    draw = true
    if draw then
        if self._redrawScreen then
            frameProfiler:startTimer("Drawing")

            gfx.clear()
            gfx.sprite.update()
            self.worldManager:draw()
            self.logManager:draw()
            self._redrawScreen = false

            frameProfiler:endTimer("Drawing")
            frameProfiler:frameEnd()
        end
    
        if self.fps then
            playdate.drawFPS(0,0)
        end
    end
    
end

function screenManager:redrawScreen()
    self:resetDrawnGlyphs()
    self._redrawScreen = true
end

function screenManager:setWorldFont(value)
    if value == "8px" then
        self.currentWorldFont = self.worldFont_8px
    elseif value == "10px" then
        self.currentWorldFont = self.worldFont_10px
    elseif value == "16px" then
        self.currentWorldFont = self.worldFont_16px
    end
    self.gridScreenMax.x = math.floor(self.screenDimensions.x / self.currentWorldFont.size)
    self.gridScreenMax.y = math.floor(self.screenDimensions.y / self.currentWorldFont.size)
    self:resetFontGlyphs()
    self:redrawScreen()
end

function screenManager:setLogFont(value)
    if value == "6px" then
        self.currentLogFont = self.logFont_6px
    elseif value == "8px" then
        self.currentLogFont = self.logFont_8px
    elseif value == "12px" then
        self.currentLogFont = self.logFont_12px
    end
    if (self.logManager ~= nil) then
        self.logManager:resplitLines()
    end
    self:redrawScreen()
end

function screenManager:getGlyph(char, inView, lightLevel)
    if (self.worldGlyphs[char] == nil) then
        self.worldGlyphs[char] = self.currentWorldFont.font:getGlyph(char)
        self.worldGlyphs_faded[char] = self.worldGlyphs[char]:fadedImage(0.5, playdate.graphics.image.kDitherTypeBayer2x2)
    end
    
    if (inView) then
        if lightLevel >= 2 then -- lit
            return self.worldGlyphs[char]
        elseif lightLevel == 1 then -- dim
            return self.worldGlyphs_faded[char]
        end
    end
    return self.worldGlyphs_faded[char] -- seen but not inview
end

function screenManager:drawGlyph(char, tile, drawCoord)
    local glyph = self:getGlyph(char, tile.inView, tile.lightLevel)

    local drawnGlyph = self.drawnGlyphs[drawCoord.x][drawCoord.y]
    if (drawnGlyph == nil or drawnGlyph ~= glyph) then
        self.drawnGlyphs[drawCoord.x][drawCoord.y] = glyph

        if (tile.currentVisibilityState == tile.visibilityState.lit or tile.currentVisibilityState == tile.visibilityState.dim) then -- draw light around rect
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRect(drawCoord.x, drawCoord.y, self.currentWorldFont.size, self.currentWorldFont.size)
        end
        glyph:draw(drawCoord.x, drawCoord.y)

    end
end

function screenManager:resetFontGlyphs()
    self.worldGlyphs = {}
    self.worldGlyphs_faded = {}
    --collectgarbage()
end

function screenManager:resetDrawnGlyphs()
    for x = 0, self.gridScreenMax.x, 1 do
        self.drawnGlyphs[x] = {}
        for y = 0, self.gridScreenMax.y, 1 do
            self.drawnGlyphs[x][y] = ""
            print(x, y)
        end
    end

end