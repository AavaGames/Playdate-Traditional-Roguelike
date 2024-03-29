local gfx <const> = playdate.graphics

class("ScreenManager").extends()

function ScreenManager:init()
    self.fps = false
    self.targetFPS = 30

    self.debugViewportBlocksDraw = false

    self.screenDimensions = {
        x = 400,
        y = 240
    }

    self.levelFont_8px = { font = gfx.font.new('assets/fonts/Rainbow100_re_40'), size = { width = 9, height = 10 } }
    self.levelFont_10px = { font = gfx.font.new('assets/fonts/Log/Nix8810_M15'), size = { width = 11, height = 13 } }
    self.levelFont_16px = { font = gfx.font.new('assets/fonts/IBM/IBM_EGA_8x8_2x'), size = { width = 16, height = 16 } }

    self.logFont_6px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/DOS/dos-jpn12-6x12",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/DOS/dos-jpn12-6x12", -- TODO make bold
    }), size = { width = 6, height = 12 }, lineCount = 5, fullLineCount = 19 }
    self.logFont_8px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/CompaqThin_8x16",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Nix8810_M15",
    }), size = { width = 8, height = 16 }, lineCount = 4, fullLineCount = 14 }
    self.logFont_12px = { font = playdate.graphics.font.newFamily({
        [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/Portfolio_6x8_2x",
        [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Portfolio_6x8_2x", -- TODO make bold
    }), size = { width = 12, height = 16 }, lineCount = 4, fullLineCount = 14 }

    self.currentLevelFont, self.currentLogFont = nil, nil

    self.fullLevelViewport = function(self)
        local x = (self.screenDimensions.x - ((self.screenDimensions.x // self.currentLevelFont.size.width) * self.currentLevelFont.size.width)) // 2
        local y = (self.screenDimensions.y - ((self.screenDimensions.y // self.currentLevelFont.size.height) * self.currentLevelFont.size.height)) // 2
        local v = {
            x = x + 1,
            y = y + 1,
            width = self.screenDimensions.x - x * 2,
            height = self.screenDimensions.y - y * 2
        }
        return v
    end
    self.viewportCalcFunction = self.fullLevelViewport
    self.viewport = nil

    -- Max characters that can be drawn in the viewport
    self.viewportGlyphDrawMax = { x = 0, y = 0 }

    -- lit, dim but seen, unseen but known
    self.levelGlyphs = {} -- alloc an estimate?
    self.levelGlyphs_faded = {}
    self.drawnGlyphs = {}

    playdate.display.setRefreshRate(self.targetFPS)

    self.bgColor = gfx.kColorBlack
    self.levelColor = gfx.kColorWhite

    self.levelManager, self.logManager, self.menuManager = nil, nil, nil
    self._redrawScreen = true

    self._redrawLevel = false
    self._redrawLog = false
    self._redrawMenu = false

    playdate.keyboard.keyboardAnimatingCallback = function ()
        if gameManager:isState(gameManager.GameStates.Level) then
        elseif gameManager:isState(gameManager.GameStates.FullLog) then
            self:redrawScreen()
        elseif gameManager:isState(gameManager.GameStates.Menu) then
        end
    end
    playdate.keyboard.keyboardDidHideCallback = function ()
        self:redrawScreen()
    end

    self:setLevelFont("16px")
    self:setLogFont("8px")
    self:resetDrawnGlyphs()
end

function ScreenManager:setBGColor(color)
    self.bgColor = color
    self.levelColor = color == gfx.kColorBlack and gfx.kColorWhite or gfx.kColorBlack
    gfx.setBackgroundColor(self.bgColor)
    self:redrawScreen()
end

function ScreenManager:update()
    if (gameManager:isState(gameManager.GameStates.Level)) then
        self.combatView = not inputManager:isCrankDocked()
    end
end
function ScreenManager:lateUpdate() end

--#region Draws

function ScreenManager:draw()
    local drew = false

    if (self._redrawScreen == true) then
        frameProfiler:startTimer("Draw: Screen Clear")
        gfx.clear()
        frameProfiler:endTimer("Draw: Screen Clear")
    end

    if gameManager:isState(gameManager.GameStates.Level) then
        drew = self:drawLevel()
        local drewLog = self:drawLog()
        drew = drew and drew or drewLog

        if self.debugViewportBlocksDraw then
            self:debugDrawViewportBlocks()
        end

    elseif gameManager:isState(gameManager.GameStates.FullLog) then
        drew = self:drawLog()
    elseif gameManager:isState(gameManager.GameStates.Menu) then
        drew = self:drawMenu()
    end

    if self.fps then
        playdate.drawFPS(0,0)
    end

    self._redrawScreen = false
    frameProfiler:endFrame(drew)
end

function ScreenManager:drawMenu()
    local drew = false
    if (self._redrawMenu == true) then
        frameProfiler:startTimer("Draw: Menu")

        self.menuManager:draw()
        self._redrawMenu = false

        frameProfiler:endTimer("Draw: Menu")
    end
    return drew
end

function ScreenManager:drawLevel()
    local drew = false
    if (self._redrawLevel == true) then
        frameProfiler:startTimer("Draw: Level")

        self.levelManager:draw()
        self._redrawLevel = false
        drew = true

        frameProfiler:endTimer("Draw: Level")
    end
    return drew
end

function ScreenManager:drawLog()
    local drew = false
    if (self._redrawLog == true) then
        frameProfiler:startTimer("Draw: Log")

        self.logManager:draw()
        self._redrawLog = false
        drew = true

        frameProfiler:endTimer("Draw: Log")
    end
    return drew
end

function ScreenManager:debugDrawViewportBlocks()
    gfx.clear()
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setColor(self.levelColor)
    if (self.logManager.showingLog) then
        gfx.fillRect(self.logManager.currentLogViewport.dimensions.x, self.logManager.currentLogViewport.dimensions.y, 
            self.logManager.currentLogViewport.dimensions.width, self.logManager.currentLogViewport.dimensions.height)
        gfx.drawText("LOG", self.logManager.currentLogViewport.dimensions.x, self.logManager.currentLogViewport.dimensions.y)
    end
    gfx.fillRect(self.viewport.x, self.viewport.y, self.viewport.width, self.viewport.height)
    gfx.drawText("LEVEL", self.viewport.x, self.viewport.y)
end

--#endregion

function ScreenManager:redrawScreen()
    self:resetDrawnGlyphs()
    self._redrawScreen = true

    self:redrawLevel()
    self:redrawLog()
    self:redrawMenu()
end

function ScreenManager:redrawingScreen()
    return self._redrawScreen
end

function ScreenManager:redrawLevel()
    self._redrawLevel = true
end

function ScreenManager:redrawLog()
    self._redrawLog = true
end

function ScreenManager:redrawMenu()
    self._redrawMenu = true
end

function ScreenManager:setLevelFont(value)
    if value == "8px" then
        self.currentLevelFont = self.levelFont_8px
    elseif value == "10px" then
        self.currentLevelFont = self.levelFont_10px
    elseif value == "16px" then
        self.currentLevelFont = self.levelFont_16px
    end
    self:recalculateViewport()
    self:resetFontGlyphs()
    self:redrawScreen()
end

function ScreenManager:setLogFont(value)
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

--#region Glyphs 

function ScreenManager:getGlyphImage(glyph, lightLevel)
    if (self.levelGlyphs[glyph] == nil) then
        self.levelGlyphs[glyph] = self.currentLevelFont.font:getGlyph(glyph)
        self.levelGlyphs_faded[glyph] = self.levelGlyphs[glyph]:fadedImage(0.5, gfx.image.kDitherTypeBayer2x2)
    end
    
    if lightLevel >= 1 then -- lit
        return self.levelGlyphs[glyph]
    else -- dim or seen
        return self.levelGlyphs_faded[glyph]
    end
end

function ScreenManager:drawGlyph(glyph, tile, drawCoord, screenCoord)
    local drawnGlyph = self.drawnGlyphs[screenCoord.x][screenCoord.y]

    if (not (drawnGlyph.glyph == "" and glyph == "")) then
        local tileLit = tile ~= nil and tile.lightLevel > 0
        local tileLightLevel = tile ~= nil and tile.lightLevel or 0

        -- no need to redraw if everything is the same
        if (not (drawnGlyph.glyph == glyph and drawnGlyph.lightLevel == tileLightLevel)) then 
            -- TODO figure out if this could work. Using glyph as eraser rather than a rect

            -- if (drawnGlyph.lit == true and tileLit == false) then
            --     -- tile is now NOT lit, needs to be filled in, no need to erase glyph
            --     gfx.setColor(self.bgColor)
            --     gfx.fillRect(drawCoord.x, drawCoord.y, self.currentLevelFont.size, self.currentLevelFont.size)
            -- elseif (drawnGlyph.image ~= nil) then
            --     -- lit state the same as previous
            --     pDebug:log("erasing " .. drawnGlyph.glyph)
            --     gfx.setImageDrawMode(gfx.kDrawModeXOR) -- same color as bg
            --     local image = self:getGlyphImage(drawnGlyph.glyph, true, 2)
            --     image:draw(drawCoord.x, drawCoord.y)
            -- end

            -- clear tile
            gfx.setColor(self.bgColor)
            gfx.fillRect(drawCoord.x, drawCoord.y, self.currentLevelFont.size.width, self.currentLevelFont.size.height)
            
            -- draw new glyph image and update table
            self.drawnGlyphs[screenCoord.x][screenCoord.y] = { glyph = glyph, lightLevel = tileLightLevel, lit = tileLit, image = nil}
            if (glyph ~= "") then
                local image = self:getGlyphImage(glyph, tile.lightLevel)
                self.drawnGlyphs[screenCoord.x][screenCoord.y].image = image
                if (tile.lightLevel >= 2) then -- draw light around rect
                    gfx.setColor(gfx.kColorWhite)
                    gfx.fillRect(drawCoord.x, drawCoord.y, self.currentLevelFont.size.width, self.currentLevelFont.size.height)
                end
                image:draw(drawCoord.x, drawCoord.y)
            end
        end
    end
end

function ScreenManager:resetFontGlyphs()
    self.levelGlyphs = {}
    self.levelGlyphs_faded = {}
end

function ScreenManager:resetDrawnGlyphs()
    for x = 0, self.viewportGlyphDrawMax.x, 1 do
        self.drawnGlyphs[x] = {}
        for y = 0, self.viewportGlyphDrawMax.y, 1 do
            self.drawnGlyphs[x][y] = { glyph = "", lightLevel = 0, lit = false, image = nil}
        end
    end
end

--#endregion

--#region Viewport

function ScreenManager:setViewport(viewportCalcFunction)
    -- IDEA: Coroutine to have smooth transition
    local func = viewportCalcFunction or self.fullLevelViewport
    self.viewportCalcFunction = func
    self:recalculateViewport()
    self:redrawScreen()
end

function ScreenManager:recalculateViewport()
    self.viewport = self:viewportCalcFunction()
    self.viewportGlyphDrawMax = {
        x = self.viewport.width // self.currentLevelFont.size.width,
        y = self.viewport.height // self.currentLevelFont.size.height
    }
    if (gameManager ~= nil and gameManager.levelManager.currentLevel.camera ~= nil) then
        gameManager.levelManager.currentLevel.camera:calculateBounds()
    end 
end

--#endregion