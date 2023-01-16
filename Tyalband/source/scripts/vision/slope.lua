local gfx <const> = playdate.graphics

class("slope").extends()

function slope:init(y, x)
    self.y = y
    self.x = x
end

function slope:greater(y, x)
    return self.y*x > self.x*y
end

function slope:greaterOrEqual(y, x)
    return self.y*x >= self.x*y
end

function slope:less(y, x)
    return self.y*x < self.x*y
end

function slope:lessOrEqual(y, x)
    return self.y*x <= self.x*y
end