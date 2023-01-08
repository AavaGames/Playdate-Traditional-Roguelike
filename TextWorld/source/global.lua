import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

-- Global Variables --

screenDimensions = {
    x = 400,
    y = 240
}

targetFPS = 30

fontSize = 16;
geebee = gfx.font.new('assets/fonts/Gee Bee')
sans = gfx.font.new('assets/fonts/Mini Sans/Mini Sans')
mono = gfx.font.new('assets/fonts/Mini Mono/Mini Mono')
mono2 = gfx.font.new('assets/fonts/Mini Mono 2X/Mini Mono 2X')

worldFont = mono2
logFont = sans
showLog = false

xMax = screenDimensions.x / fontSize
yMax = screenDimensions.y / fontSize

defaultDrawMode = playdate.graphics.kDrawModeNXOR

function clamp(number, min, max)
    if number < min then
        number = min
    elseif number > max then
        number = max
    end
    return number
end