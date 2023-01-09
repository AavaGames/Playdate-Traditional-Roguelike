import "~imports"

local gfx <const> = playdate.graphics

-- Global Variables --

screenDimensions = {
    x = 400,
    y = 240
}

fps = true
targetFPS = 30

fontSize = 16;
geebee = gfx.font.new('assets/fonts/Gee Bee')
sans = gfx.font.new('assets/fonts/Mini Sans/Mini Sans')
mono = gfx.font.new('assets/fonts/Mini Mono/Mini Mono')
mono2 = gfx.font.new('assets/fonts/Mini Mono 2X/Mini Mono 2X')

worldFont = mono2
logFont = sans

showLog = true

xMax = screenDimensions.x / fontSize
yMax = screenDimensions.y / fontSize

defaultDrawMode = playdate.graphics.kDrawModeNXOR