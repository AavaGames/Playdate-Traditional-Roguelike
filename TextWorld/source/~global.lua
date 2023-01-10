import "~imports"

local gfx <const> = playdate.graphics

-- Global Variables --

screenDimensions = {
    x = 400,
    y = 240
}

fps = true
targetFPS = 30

-- world fonts
worldFont_8px = gfx.font.new('assets/fonts/IBM/final/IBM_EGA_8x8') -- 8px
worldFont_10px = gfx.font.new('assets/fonts/Rainbow100_re_40') -- 10px
worldFont_16px = gfx.font.new('assets/fonts/IBM/final/IBM_EGA_8x8_2x') -- 16px

-- log fonts
logFont_6px = playdate.graphics.font.newFamily({
    [playdate.graphics.font.kVariantNormal] = "assets/fonts/DOS/dos-jpn12-6x12",
    [playdate.graphics.font.kVariantBold] = "assets/fonts/DOS/dos-jpn12-6x12", -- TODO make bold
})
logFont_8px = playdate.graphics.font.newFamily({
    [playdate.graphics.font.kVariantNormal] = "assets/fonts/Log/CompaqThin_8x16",
    [playdate.graphics.font.kVariantBold] = "assets/fonts/Log/Nix8810_M15",
})
logFont_12px = playdate.graphics.font.newFamily({
    [playdate.graphics.font.kVariantNormal] = "assets/fonts/Portfolio_6x8_2x",
    [playdate.graphics.font.kVariantBold] = "assets/fonts/Portfolio_6x8_2x", -- TODO make bold
})

fontSize = 16
worldFont = worldFont_16px
logFont = logFont_8px

showLog = true

xMax = screenDimensions.x / fontSize
yMax = screenDimensions.y / fontSize

defaultDrawMode = playdate.graphics.kDrawModeNXOR