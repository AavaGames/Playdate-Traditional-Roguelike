import "global"

class("logManager").extends()

local gfx <const> = playdate.graphics

function logManager:init()
	self.log = {}

    self.position = { x = 16, y = 240-fontSize*5}

    -- log.add("This is text")
    -- log.add("You take _ damage")
    -- log.add("Super duper long text string that should be off the screen by now")
end

function logManager:draw()
   
end

function logManager:update()

end

function logManager:add(text)

end