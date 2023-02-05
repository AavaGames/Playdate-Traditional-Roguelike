class("LogManager").extends()

local gfx <const> = playdate.graphics

function LogManager:init(theLevelManager)
    screenManager.logManager = self
    self.levelManager = theLevelManager

    self.cleanLog = {} -- holds full lines of the log
	self.log = {} -- holds lines trimmed to fit the log view
    self.showingLog = true
    self.maxLogLines = 500 -- TODO: implement (34 avg char x 500 lines = 17 000 bytes)

    self.textPosition = { x = 5, y = 173}
    self.textSize = { x = 400-8, y = 64 }
    
    self.lineMultiple = 1
    self.currentLineOffset = 0

    self.logCrankTicks = 12

    self.logVisibleViewport = function ()
        return {
            x = 1,
            y = 1,
            width = 400,
            height = math.floor(screenManager.screenDimensions.y * 0.70)
        }
    end

    self.dimensions = { x = 1, y = math.floor(screenManager.screenDimensions.y * 0.7) + 1,
        width = 400 - 2, height = math.floor(screenManager.screenDimensions.y * 0.3) - 2}
    -- Inspect Window Dimensions
    -- self.textPosition = { x = math.floor(screenManager.screenDimensions.x * 0.5) + 3, y = 2}
    -- self.textSize = { x = math.floor(screenManager.screenDimensions.x * 0.5)-6, y = screenManager.screenDimensions.y}
    -- self.dimensions = { x = math.floor(screenManager.screenDimensions.x * 0.5), y = 1, width = math.floor(screenManager.screenDimensions.x * 0.5)-1, height = screenManager.screenDimensions.y -2}
    -- self.inspectViewport = function ()
    --     return {
    --         x = 1,
    --         y = 1,
    --         width = math.floor(screenManager.screenDimensions.x * 0.5),
    --         height = screenManager.screenDimensions.y
    --     }
    -- end

    self.logBorder = Border(self.dimensions.x, self.dimensions.y, 
        self.dimensions.width, self.dimensions.height, 2, gfx.kColorXOR)

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
    --self:add("---")
    --self:add("This is a dragon. It is *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")
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
        gfx.drawTextInRect(text, self.textPosition.x, self.textPosition.y, self.textSize.x, self.textSize.y)

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

        if gfx.getTextSize(testLine) > self.textSize.x then
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