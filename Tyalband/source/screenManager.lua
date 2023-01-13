local gfx <const> = playdate.graphics

class("screenManager").extends()

function screenManager:init()
    self.fps = true
    self.targetFPS = 30

    self.screenDimensions = {
        x = 400,
        y = 240
    }

    self.worldFont_8px = { font = gfx.font.new('assets/fonts/IBM/final/IBM_EGA_8x8'), size = 8 }
    self.worldFont_10px = { font = gfx.font.new('assets/fonts/Rainbow100_re_40'), size = 10 }
    self.worldFont_16px = { font = gfx.font.new('assets/fonts/IBM/final/IBM_EGA_8x8_2x'), size = 16 }

    self.logFont_6px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/DOS/dos-jpn12-6x12",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/DOS/dos-jpn12-6x12", -- TODO make bold
    }), size = 6 }
    self.logFont_8px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/CompaqThin_8x16",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Nix8810_M15",
    }), size = 8 }
    self.logFont_12px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Portfolio_6x8_2x",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Portfolio_6x8_2x", -- TODO make bold
    }), size = 12 }

    self.currentWorldFont, self.currentLogFont = nil, nil

    -- Maxmimum characters that can fit on the screen
    self.gridScreenMax = { x = 0, y = 0 }

    -- lit, dim but seen, unseen but known
    self.worldGlyphs = {} -- alloc an estimate?
    self.worldGlyphs_dim = {}

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
	gfx.setBackgroundColor(gfx.kColorBlack)

    self.worldManager, self.logManager = nil, nil
    self._drawWorld = true;
    self._drawLog = false;

    self:setWorldFont("16px")
    self:setLogFont("8px")

    self.bgBlack= true;
end

function screenManager:invertColors()
    gfx.setBackgroundColor(self.bgBlack and gfx.kColorBlack or gfx.kColorWhite)
    self.bgBlack = not self.bgBlack
    print("invert")
    self._redrawScreen = true
    --playdate.timer.performAfterDelay(10000, invertColors)
end

function screenManager:update() end
function screenManager:lateUpdate() end

function screenManager:draw()
    draw = true
    if draw then
        if self._redrawScreen then
            gfx.clear()
            gfx.sprite.update()
            self._drawWorld = true
            self._drawLog = true
            self._redrawScreen = false
        end
    
        if self._drawWorld then
            -- replace with clear world
            gfx.clear()
            gfx.sprite.update()
    
            self.worldManager:draw()
            --self.logManager:draw()
            self._drawWorld = false
        end
    
        if self._redrawLog then
            -- clear log
            self.logManager:draw()
            self._redrawLog = false
        end
    
        if self.fps then
            playdate.drawFPS(0,0)
        end
    end
    
end

-- 
function screenManager:redrawWorld(redrawEverything)
    self._drawWorld = true
    if redrawScreen then self._redrawScreen = true end
end

function screenManager:redrawLog(redrawEverything)
    self._drawLog = true
    if redrawScreen then self._redrawScreen = true end
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
    self:clearGlyphs()
    self:redrawWorld(false)
end

function screenManager:setLogFont(value)
    if value == "6px" then
        self.currentLogFont = self.logFont_6px
    elseif value == "8px" then
        self.currentLogFont = self.logFont_8px
    elseif value == "12px" then
        self.currentLogFont = self.logFont_12px
    end
    self:redrawLog(false)
end

function screenManager:getGlyph(char, visibility)
    if (self.worldGlyphs[char] == nil) then
        self.worldGlyphs[char] = self.currentWorldFont.font:getGlyph(char)
        self.worldGlyphs_dim[char] = self.worldGlyphs[char]:fadedImage(0.5, playdate.graphics.image.kDitherTypeBayer2x2)
    end
    
    if visibility == 1 then -- lit
        return self.worldGlyphs[char]
    elseif visibility == 2 then -- dim
        return self.worldGlyphs[char]
    else
        return self.worldGlyphs_dim[char] -- replace with SEEN
    end
end

function screenManager:clearGlyphs()
    self.worldGlyphs = {}
    self.worldGlyphs_dim = {}
    collectgarbage()
end