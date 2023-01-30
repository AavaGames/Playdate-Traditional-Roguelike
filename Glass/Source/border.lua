class("border").extends()

local gfx <const> = playdate.graphics

function border:init( posX, posY, sizeX, sizeY, thickness, color )
	self.position = { x = posX, y = posY }
	self.size = { x = sizeX, y = sizeY}
	self.thickness = thickness
	self.color = playdate.graphics.kColorXOR
end

function border:draw()
    gfx.setColor(self.color)

	gfx.fillRect(self.position.x, self.position.y, self.size.x, self.thickness) -- north
	gfx.fillRect(self.position.x, self.position.y + self.size.y - self.thickness, self.size.x, self.thickness) -- south
	gfx.fillRect(self.position.x + self.size.x - self.thickness, self.position.y + self.thickness, self.thickness, 
		self.size.y - self.thickness * 2) -- east
    gfx.fillRect(self.position.x, self.position.y + self.thickness, self.thickness, 
		self.size.y - self.thickness * 2) -- west
end