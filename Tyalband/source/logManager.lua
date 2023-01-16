class("logManager").extends()

local gfx <const> = playdate.graphics

function logManager:init(theWorldManager)
    screenManager.logManager = self
    self.worldManager = theWorldManager

    self.cleanLog = {} -- holds full lines of the log
	self.log = {} -- holds lines trimmed to fit the log view
    self.showingLog = true
    self.maxLogLines = 500 -- TODO: implement (34 avg char x 500 lines = 17 000 bytes)

    self.position = { x = 12, y = 165}
    self.size = { x = 400-24, y = 64 }
    
    self.linePadding = 2

    self.currentLineOffset = 0

    self.logVisibleViewport = {
        x = screenManager.currentWorldFont.size,
        y = screenManager.currentWorldFont.size,
        width = screenManager.screenDimensions.x - screenManager.currentWorldFont.size * 2,
        height = screenManager.screenDimensions.y * 0.6
    }

    self.logBorder = border(8, 162, 400-16, 70, 2, gfx.kColorBlack)

    self:hideLog()

    self:add("Line 1.")
    self:add("This is text...")
    self:add("Super duper long text string that should be off the screen a a a by now.")
    self:add("You hit the skeleton for 5 damage.")
    self:add("The skeleton misses you.")
    self:add("This is a scroll of magic missle.")
    
    --self:add("This is a dragon. It is slow and attacks often. It has a breath weapon that deals 60 damage (average) and its attacks deal 16 damage (average).")

    self:add("This is a dragon. It is *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average). It is immune to *fire* and *gas* based attacks but weak to *piercing*.")

    self:add("You pick up the stone axe of the dwarven kingdom of Irunel. It has 25 blah and can pierce armor of the highest grade. Only those with the mightest of shields can block such a blade.")
end

function logManager:showLog()
    if (not self.showingLog) then
        -- log view
        self.worldManager:setViewport(self.logVisibleViewport)
        self.showingLog = true
        self.currentLineOffset = 0
        screenManager:redrawScreen()
    end
end

function logManager:hideLog()
    if (self.showingLog) then
        -- default fullscreen view
        self.worldManager:setViewport()
        self.showingLog = false
    end
end

function logManager:draw()
    if (self.showingLog) then
        gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)
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

function logManager:update()
    if not playdate.isCrankDocked() then
        if not self.showingLog then
            self:showLog()
        end
    else
        if (self.showingLog) then
            self:hideLog()
        end
    end

    
    local ticks = 12
    local crankTick = playdate.getCrankTicks(ticks)
    if crankTick ~= 0 then
        self.currentLineOffset -= crankTick
        self.currentLineOffset = math.clamp(self.currentLineOffset, 0, #self.log - screenManager.currentLogFont.lineCount)
        screenManager:redrawScreen()
    end
end

function logManager:add(text)
    table.insert(self.cleanLog, text)

    self:splitLine(text)

    if (self.showingLog) then
        self.currentLineOffset = 0
        screenManager:redrawScreen()
    end
end

function logManager:splitLine(text)
    -- split sentence
    local words = {}
    local sep = " "
    for word in string.gmatch(text, "([^"..sep.."]+)") do
        table.insert(words, word)
    end

    gfx.setFont(screenManager.currentLogFont.font)

    local line = ""
    local i = 1
    while i < #words+1 do
        local space = line ~= "" and " " or "" -- add a space unless its new line
        local testLine = line .. space .. words[i]

        if gfx.getTextSize(testLine) > self.size.x then
            table.insert(self.log, line)
            line = ""
            i -= 1
        else
            line = testLine
        end
        i += 1
    end

    if (line ~= "") then
        table.insert(self.log, line)
    end
end

function logManager:resplitLines()
    self.log = {}
    self.currentLineOffset = 0
    for index, line in ipairs(self.cleanLog) do
        self:splitLine(line)
    end
end