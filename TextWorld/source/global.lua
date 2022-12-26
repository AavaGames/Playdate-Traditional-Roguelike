import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Global Variables --

targetFPS = 30

fontSize = 8;

xMax = 400 / fontSize
yMax = 240 / fontSize

screen = {
    x = 400,
    y = 240
}

worldDimension = { x = 100, y = 100 }

defaultDrawMode = playdate.graphics.kDrawModeNXOR

function clamp(number, min, max)
    if number < min then
        number = min
    elseif number > max then
        number = max
    end
    return number
end