class("logManager").extends()

local gfx <const> = playdate.graphics

function logManager:init()
	self.log = {}

    self.position = { x = 14, y = 240-74}
    self.size = { x = 400-26, y = 64 }

    self.fontSize = 8
    self.linePadding = 2

    self.lineCount = 4

    self.currentLine = -1

    logBorder = border(10, 162, 400-22, 66, 2, gfx.kColorBlack)

    table.insert(self.log, "This is text")
    table.insert(self.log, "You take X damage")
    table.insert(self.log, "Super duper long text string that should be off the screen a a a by now")
    table.insert(self.log, "This is text 2")
    table.insert(self.log, "This is text 3")
    table.insert(self.log, "This is text 4")
    table.insert(self.log, "Super duper long text string that should be off the screen a a a by now")
end

function logManager:draw()
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

function logManager:update()

end

function logManager:add(text)
    table.insert(self.log, text)
end