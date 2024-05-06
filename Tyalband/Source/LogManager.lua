---@class LogManager : Object
---@overload fun(theLevelManager: LevelManager): LogManager
LogManager = class("LogManager").extends() or LogManager

local gfx <const> = playdate.graphics
local logCrankTicks <const> = 12

function LogManager:init(theLevelManager)
    self.screenManager = screenManager
    self.screenManager.logManager = self
    self.levelManager = theLevelManager
    self.player = theLevelManager.player

    -- the line of the current round, all events are added together to one large line
    self.roundLine = "" 
    self.cleanLog = {} -- holds full lines of the log
	self.log = {} -- holds lines trimmed to fit the log view
    self.showingLog = true
    self.fullscreen = false
    self.maxLogLines = 500 -- TODO: implement (34 avg glyph x 500 lines = 17 000 bytes)

    self.lineMultiple = 1
    self.currentLineOffset = 0

    self.fontLineCount = nil
    self:getFontLineCount()

    local levelHeight = math.floor(screenManager.screenDimensions.y * 0.71)
    self.combatViewport = function ()
        local xOffset = self.levelManager.currentLevel.healthDisplay.font.size.width
        local width = screenManager.screenDimensions.x - xOffset * 2
        local height = levelHeight
        local x = (width - ((width // screenManager.currentLevelFont.size.width) * screenManager.currentLevelFont.size.width)) // 2
        local y = (height - ((height // screenManager.currentLevelFont.size.height) * screenManager.currentLevelFont.size.height)) // 2
        local v = {
            x = x + xOffset + 1,
            y = y + 1,
            width = width - x * 2,
            height = height - y * 2
        }
        return v
    end

    self.levelLogViewport = {
        textPosition = { x = 5, y = 173},
        textSize = { x = 400-8, y = 64 },
        dimensions = { x = 0, y = math.floor(screenManager.screenDimensions.y * 0.71),
            width = 400, height = math.floor(screenManager.screenDimensions.y * 0.29) + 1}
    }

    self.fullLogViewport = {
        textPosition = { x = 5, y = 5},
        textSize = { x = 390, y = 230 },
        dimensions = { x = 0, y = 0, width = 400, height = 240}
    }

    self.currentLogViewport = self.levelLogViewport

    self.levelLogBorder = Border(self.levelLogViewport.dimensions.x, self.levelLogViewport.dimensions.y, 
                            self.levelLogViewport.dimensions.width, self.levelLogViewport.dimensions.height, 2, gfx.kColorXOR)
    self.fullLogBorder = Border(self.fullLogViewport.dimensions.x, self.fullLogViewport.dimensions.y, 
                            self.fullLogViewport.dimensions.width, self.fullLogViewport.dimensions.height, 2, gfx.kColorXOR)

    self:hideLog()

    -- self:add("Line 1.")
    -- self:add("This is a scroll of magic missle.")
    -- self:add("This is a scroll of magic missle.")
    -- self:add("This is a scroll of magic missle.")
    -- self:add("This is a dragon. It has 45 HP (average). It is *slow* and attacks often. It has a *breath* *weapon* that deals 60 damage and its attacks deal 16 damage. It is immune to *fire* and *gas*, resistant to *poison* and weak to *piercing* and *electric*.")
    -- self:addToRound("%s hits the skeleton, catching it unaware!")
    -- self:addRoundLineToLog()
    -- self:addToRound("%s hits the skeleton.")
    -- self:addToRound("The skeleton misses.")
    -- self:addRoundLineToLog()
    -- self:addToRound("%s hits the skeleton.")
    -- self:addToRound("The skeleton falls into rubble.")
    -- self:addRoundLineToLog()
    -- self:add("%s picks up the *Great* *Axe* *of* *Irunel.*")--It has 25 blah and can pierce armor of the highest grade. Only those with the mightest of shields can block such a blade.")
    -- self:add("---")
    --     -- self:add("This is a dragon. It is 4*slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
    -- self:add("This is a dragon. It is3 *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
    -- self:add("This is a dragon. It is *s5ow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")

end

function LogManager:showLog()
    if (not self.showingLog) then
        screenManager:setViewport(self.combatViewport) -- log view
        self.showingLog = true
        self.currentLineOffset = 0
        screenManager:redrawScreen()
    end
end

function LogManager:hideLog()
    if (self.showingLog) then
        screenManager:setViewport() -- default fullscreen view
        self.showingLog = false
    end
end

function LogManager:addRoundLineToLog()
    if (self.roundLine ~= "") then
        self:add(self.roundLine)
        self.roundLine = ""
    end
end

function LogManager:draw()
    if (self.showingLog) then
        -- Clear
        gfx.setColor(screenManager.bgColor)
        gfx.fillRect(self.currentLogViewport.dimensions.x, self.currentLogViewport.dimensions.y, 
                    self.currentLogViewport.dimensions.width, self.currentLogViewport.dimensions.height)
        -- Draw
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.setFont(screenManager.currentLogFont.font)

        local text = ""
        for i = self.currentLineOffset - 1 + self.fontLineCount, self.currentLineOffset, -1 do
            if (self.log[#self.log-i]) then
                text = text .. self.log[#self.log-i] .. "\n"
            end
        end
        gfx.drawTextInRect(text, self.currentLogViewport.textPosition.x, self.currentLogViewport.textPosition.y, self.currentLogViewport.textSize.x, self.currentLogViewport.textSize.y)

        if (self.fullscreen) then
            self.fullLogBorder:draw()
        else
            self.levelLogBorder:draw()
        end
    end
end

function LogManager:update()
    self.previousLineOffset = self.currentLineOffset

    local crankTick = inputManager:getCrankTicks(logCrankTicks)
    if crankTick ~= 0 then
        self:addLineOffset(-crankTick)
    end

    if (self.fullscreen == true) then
        if (inputManager:justPressed(playdate.kButtonB)) then
            gameManager:setFullscreenLog(false)
        end

        local prevOffset = self.currentLineOffset
        if (inputManager:justPressed(playdate.kButtonUp)) then -- TODO add held timer
            self:addLineOffset(1)
        elseif (inputManager:justPressed(playdate.kButtonDown)) then
            self:addLineOffset(-1)
        end
    else
        if screenManager.combatView then
            self:showLog()
        else
            self:hideLog()
        end
    end

    if (inputManager:justCrankDocked()) then
        self.currentLineOffset = 0
    end

    if (self.currentLineOffset ~= self.previousLineOffset) then
        screenManager:redrawLog()
    end
end

function LogManager:lateUpdate()
    self:addRoundLineToLog()
end

function LogManager:add(text)
    text = self:addPlayerNameToText(text)
    if (text == self.cleanLog[#self.cleanLog]) then
        self.lineMultiple = self.lineMultiple + 1
        text = text .. " <x" .. self.lineMultiple .. ">"
        for i = 1, self.lastLinesCreated, 1 do
            table.remove(self.log, #self.log)
        end
    else
        self.lineMultipleCausedSplit = false
        self.lineMultiple = 1
        table.insert(self.cleanLog, text)
    end
    self.lastLinesCreated = self:splitLine(text)

    if (self.showingLog) then
        self.currentLineOffset = 0
        screenManager:redrawLog()
    end
end

-- Text must capitalize the sentence and end in punctuation.
function LogManager:addToRound(text)
    text = self:addPlayerNameToText(text)
    -- adds to a line that is split before drawing
    local separator <const> = " "
    local sep = self.roundLine == "" and "" or separator
    self.roundLine = self.roundLine .. sep .. text
    screenManager:redrawLog()
end

function LogManager:addPlayerNameToText(text)
    return string.format(text, self.player.name) -- formats the %s in the text
end

--#region Utility

function LogManager:addLineOffset(lines)
    self.currentLineOffset += lines
    self.currentLineOffset = math.clamp(self.currentLineOffset, 0, #self.log - self.fontLineCount)
end

function LogManager:splitLine(text)
    -- split sentence
    local words = {}
    local sep = " "
    for word in string.gmatch(text, "([^"..sep.."]+)") do
        table.insert(words, word)
    end

    gfx.setFont(screenManager.currentLogFont.font)

    local linesCreated = 0
    local line = ""
    local i = 1
    while i < #words+1 do
        local space = line ~= "" and " " or "" -- add a space unless its new line
        local testLine = line .. space .. words[i]

        if gfx.getTextSize(testLine) > self.currentLogViewport.textSize.x then
            table.insert(self.log, line)
            linesCreated += 1
            line = ""
            i -= 1
        else
            line = testLine
        end
        i += 1
    end

    if (line ~= "") then
        table.insert(self.log, line)
        linesCreated += 1
    end
    return linesCreated
end

function LogManager:getFontLineCount()
    self.fontLineCount = self.fullscreen and screenManager.currentLogFont.fullLineCount or screenManager.currentLogFont.lineCount
end

function LogManager:resplitLines()
    self.log = {}
    self.currentLineOffset = 0
    self:getFontLineCount()
    for i = 1, #self.cleanLog, 1 do
        self:splitLine(self.cleanLog[i])
    end
end

function LogManager:clearLog()
    self.cleanLog = {}
    self.log = {}
    self.currentLineOffset = 0
end

function LogManager:setFullscreen(full)
    self.fullscreen = full
    self.currentLogViewport = full and self.fullLogViewport or self.levelLogViewport
    self.currentLineOffset = 0
    self:getFontLineCount()
    if self.fullscreen then
        self:showLog()
    elseif inputManager:isCrankDocked() then
        self:hideLog()
    end
    screenManager:redrawScreen()
end