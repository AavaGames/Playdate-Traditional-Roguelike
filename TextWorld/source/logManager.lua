class("logManager").extends()

local gfx <const> = playdate.graphics

function logManager:init(theWorldManager)
    self.worldManager = theWorldManager

	self.log = {}
    self.showingLog = true

    self.position = { x = 14, y = 240-75}
    self.size = { x = 400-26, y = 64 }

    self.fontSize = 8
    self.linePadding = 2

    self.lineCount = 4

    self.currentLine = -1

    self.logVisibleViewport = {
        x = fontSize,
        y = fontSize,
        width = screenDimensions.x - fontSize * 2,
        height = screenDimensions.y * 0.6
    }

    logBorder = border(10, 162, 400-22, 66, 2, gfx.kColorBlack)

    -- table.insert(self.log, "This is text")
    -- table.insert(self.log, "Super duper long text string that should be off the screen a a a by now")
    -- table.insert(self.log, "You hit the skeleton for 5 damage.")
    -- table.insert(self.log, "The skeleton misses you.")
    -- table.insert(self.log, "This is a scroll of magic missle.")
    --table.insert(self.log, "This is a dragon. It is slow and attacks often. It has a breath weapon that deals 60 damage (average) and its attacks deal 16 damage (average).")

    table.insert(self.log, "This is a dragon. It is *slow* and attacks often. It has a *breath weapon* that deals 60 damage (average) and its attacks deal 16 damage (average).")
end

function logManager:showLog()
    if (not self.showingLog) then
        -- log view
        self.worldManager:setViewport(self.logVisibleViewport)
        self.showingLog = true
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
        gfx.setFont(logFont)
    
        local text = ""
        for i = self.lineCount-1, 0, -1 do
            if (self.log[#self.log-i]) then
                text = text .. self.log[#self.log-i] .. "\n"
            end
        end
        
        gfx.drawTextInRect(text, self.position.x, self.position.y, self.size.x, self.size.y)
    
        logBorder:draw()
        gfx.setImageDrawMode(defaultDrawMode)
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
end

function logManager:add(text)
    table.insert(self.log, text)

    self:showLog()
end