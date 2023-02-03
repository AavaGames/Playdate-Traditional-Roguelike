class("LogManager").extends()

local gfx <const> = playdate.graphics

function LogManager:init(theLevelManager)
    screenManager.logManager = self
    self.levelManager = theLevelManager

    self.cleanLog = {} -- holds full lines of the log
	self.log = {} -- holds lines trimmed to fit the log view
    self.showingLog = true
    self.maxLogLines = 500 -- TODO: implement (34 avg char x 500 lines = 17 000 bytes)

    self.position = { x = 12, y = 165}
    self.size = { x = 400-24, y = 64 }
    
    self.linePadding = 2
    self.lineMultiple = 1
    self.currentLineOffset = 0

    self.logCrankTicks = 12

    self.logVisibleViewport = function ()
        print("log view")
        return {
            x = screenManager.currentLevelFont.size,
            y = screenManager.currentLevelFont.size,
            width = screenManager.screenDimensions.x - screenManager.currentLevelFont.size * 2,
            height = math.floor(screenManager.screenDimensions.y * 0.69) - screenManager.currentLevelFont.size
        }
    end

    self.dimensions = { x = 8, y = 162, width = 384, height = 70 }
    self.logBorder = Border(self.dimensions.x, self.dimensions.y, 
        self.dimensions.width, self.dimensions.height, 2, gfx.kColorBlack)

    self:hideLog()

    self:add("Line 1.")
    self:add("This is text...")
    self:add("Super duper long text string that should be off the screen a a a by now.")
    self:add("You hit the skeleton for 5 damage.")
    self:add("The skeleton misses you.")
    self:add("This is a scroll of magic missle.")
    self:add("This is a scroll of magic missle.")
    self:add("This is a scroll of magic missle.")
    --self:add("This is a dragon. It is slow and attacks often. It has a breath weapon that deals 60 damage (average) and its attacks deal 16 damage (average).")

    self:add("This is a dragon. It is *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")

    self:add("You pick up the stone axe of the dwarven kingdom of Irunel. It has 25 blah and can pierce armor of the highest grade. Only those with the mightest of shields can block such a blade.")
end

function LogManager:showLog()
    if (not self.showingLog) then
        screenManager:setViewport(self.logVisibleViewport) -- log view
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
        gfx.fillRect(self.dimensions.x, self.dimensions.y, self.dimensions.width, self.dimensions.height)
        -- Draw
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.setFont(screenManager.currentLogFont.font)

        local text = ""
        for i = self.currentLineOffset - 1 + screenManager.currentLogFont.lineCount, self.currentLineOffset, -1 do
            if (self.log[#self.log-i]) then
                text = text .. self.log[#self.log-i] .. "\n"
            end
        end
        gfx.drawTextInRect(text, self.position.x, self.position.y, self.size.x, self.size.y)

        self.logBorder:draw()
    end
end

function LogManager:update()
    -- TODO add to input manager
    if not playdate.isCrankDocked() then
        if not self.showingLog then
            self:showLog()
        end
    else
        if (self.showingLog) then
            self:hideLog()
        end
    end

    local crankTick = playdate.getCrankTicks(self.logCrankTicks)
    if crankTick ~= 0 then
        local prevOffset = self.currentLineOffset
        self.currentLineOffset -= crankTick       
        self.currentLineOffset = math.clamp(self.currentLineOffset, 0, #self.log - screenManager.currentLogFont.lineCount)
        if (self.currentLineOffset ~= prevOffset) then
            screenManager:redrawLog()
        end
    end
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

        if gfx.getTextSize(testLine) > self.size.x then
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

function LogManager:resplitLines()
    self.log = {}
    self.currentLineOffset = 0
    for i = 1, #self.cleanLog, 1 do
        self:splitLine(self.cleanLog[i])
    end
end