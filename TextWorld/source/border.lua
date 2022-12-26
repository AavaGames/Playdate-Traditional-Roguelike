import "global"

class("border").extends()

local gfx <const> = playdate.graphics

function border:init(offset, thickness)
	self.offset = offset
	self.thickness = thickness
end

function border:draw()
    gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(self.offset , self.offset, screen.x - self.offset*2, self.thickness) -- north
	gfx.fillRect(screen.x-self.thickness-self.offset, self.offset, self.thickness, screen.y - self.offset*2) -- east
    gfx.fillRect(self.offset , screen.y - self.thickness - self.offset, screen.x - self.offset*2, self.thickness) -- south
    gfx.fillRect(self.offset, self.offset, self.thickness, screen.y - self.offset*2) -- west
end