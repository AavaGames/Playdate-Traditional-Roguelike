class("screenManager").extends()

function screenManager:init()
    self.worldGlyphs = {}

    
end

function screenManager:draw()

end

function screenManager:addGlyph(char)
    if (self.worldGlyphs[char] == nil) then
        self.worldGlyphs[char] = worldFont.getGlyph(char)
    else
        print("already contain glyph")
    end
end

function screenManager:clearGlyphs()
    self.worldGlyphs = {}
end

function screenManager:drawWorld()

end

function screenManager:drawLog()

end