class("LogManager").extends()

local gfx <const> = playdate.graphics
local logCrankTicks <const> = 12

function LogManager:init(theLevelManager)
    self.screenManager = screenManager
    self.screenManager.logManager = self
    self.levelManager = theLevelManager

    self.cleanLog = {} -- holds full lines of the log
	self.log = {} -- holds lines trimmed to fit the log view
    self.showingLog = true
    self.fullscreen = false
    self.maxLogLines = 500 -- TODO: implement (34 avg char x 500 lines = 17 000 bytes)

    self.lineMultiple = 1
    self.currentLineOffset = 0

    self.fontLineCount = nil
    self:getFontLineCount()

    self.logLevelViewport = function ()
        return {
            x = 1,
            y = 1,
            width = 400,
            height = math.floor(screenManager.screenDimensions.y * 0.70)
        }
    end

    self.levelLogViewport = {
        textPosition = { x = 5, y = 173},
        textSize = { x = 400-8, y = 64 },
        dimensions = { x = 1, y = math.floor(screenManager.screenDimensions.y * 0.7) + 1,
            width = 400 - 2, height = math.floor(screenManager.screenDimensions.y * 0.3) - 2}
    }

    self.fullLogViewport = {
        textPosition = { x = 5, y = 5},
        textSize = { x = 390, y = 230 },
        dimensions = { x = 1, y = 1, width = 400 - 2, height = 240 - 2}
    }

    self.currentLogViewport = self.levelLogViewport
    
    -- Inspect Window Dimensions
    -- self.textPosition = { x = math.floor(screenManager.screenDimensions.x * 0.5) + 3, y = 2}
    -- self.textSize = { x = math.floor(screenManager.screenDimensions.x * 0.5)-6, y = screenManager.screenDimensions.y}
    -- self.dimensions = { x = math.floor(screenManager.screenDimensions.x * 0.5), y = 1, width = math.floor(screenManager.screenDimensions.x * 0.5)-1, height = screenManager.screenDimensions.y -2}
    -- self.inspectLevelViewport = function ()
    --     return {
    --         x = 1,
    --         y = 1,
    --         width = math.floor(screenManager.screenDimensions.x * 0.5),
    --         height = screenManager.screenDimensions.y
    --     }
    -- end

    self.levelLogBorder = Border(self.levelLogViewport.dimensions.x, self.levelLogViewport.dimensions.y, 
                            self.levelLogViewport.dimensions.width, self.levelLogViewport.dimensions.height, 2, gfx.kColorXOR)
    self.fullLogBorder = Border(self.fullLogViewport.dimensions.x, self.fullLogViewport.dimensions.y, 
                            self.fullLogViewport.dimensions.width, self.fullLogViewport.dimensions.height, 2, gfx.kColorXOR)

    self:hideLog()

    self:add("Line 1.")
    self:add("This is text...")
    self:add("Super duper long text string that should be off the screen a a a by now.")
    self:add("This is a scroll of magic missle.")
    self:add("This is a scroll of magic missle.")
    self:add("This is a scroll of magic missle.")
    self:add("You hit the skeleton for 5 damage, catching it unaware.")
    self:add("You hit the skeleton for 3 damage; the skeleton misses you.")
    self:add("You destroy the skeleton.")
    self:add("You pick up the *Great* *Axe* *of* *Irunel.*")--It has 25 blah and can pierce armor of the highest grade. Only those with the mightest of shields can block such a blade.")
    self:add("---")
    self:add("This is a dragon. It i2 *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
    self:add("This is a dragon. It is 4*slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
    self:add("This is a dragon. It is3 *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
    self:add("This is a dragon. It is *s5ow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")

end

function LogManager:showLog()
    if (not self.showingLog) then
        screenManager:setViewport(self.logLevelViewport) -- log view
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
        gfx.drawTextInRect(text, self.currentLogViewport.textPosition.x, self.currentLogViewport.textPosition.y,
                                self.currentLogViewport.textSize.x, self.currentLogViewport.textSize.y)

        if (self.fullscreen) then
            self.fullLogBorder:draw()
        else
            self.levelLogBorder:draw()
        end
    end
end

function LogManager:update()
    self.previousLineOffset = self.currentLineOffset

    local crankTick = playdate.getCrankTicks(logCrankTicks)
    if crankTick ~= 0 then
        self:addLineOffset(-crankTick)
    end

    if (self.fullscreen == true) then
        if (inputManager:JustPressed(playdate.kButtonB)) then
            gameManager:setFullscreenLog(false)
        end

        local prevOffset = self.currentLineOffset
        if (inputManager:JustPressed(playdate.kButtonUp)) then -- TODO add held timer
            self:addLineOffset(1)
        elseif (inputManager:JustPressed(playdate.kButtonDown)) then
            self:addLineOffset(-1)
        end
    else
        -- TODO add crank to input manager
        if not playdate.isCrankDocked() then
            self:showLog()
        else
            self:hideLog()
        end
    end

    -- if (inputManager:crankJustDocked()) then
    --     self.currentLineOffset = 0
    -- end

    if (self.currentLineOffset ~= self.previousLineOffset) then
        screenManager:redrawLog()
    end
end

function LogManager:addLineOffset(lines)
    self.currentLineOffset += lines
    self.currentLineOffset = math.clamp(self.currentLineOffset, 0, #self.log - self.fontLineCount)
end

function LogManager:clearLog()
    self.cleanLog = {}
    self.log = {}
    self.currentLineOffset = 0
end

function LogManager:add(text)
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

function LogManager:addRound(text)
    -- adds to a line that is split before drawing


    screenManager:redrawLog()
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

function LogManager:setFullscreen(full)
    self.fullscreen = full
    self.currentLogViewport = full and self.fullLogViewport or self.levelLogViewport
    self.currentLineOffset = 0
    self:getFontLineCount()
    if self.fullscreen then
        self:showLog()
    elseif playdate.isCrankDocked() then
        self:hideLog()
    end
    screenManager:redrawScreen()
end