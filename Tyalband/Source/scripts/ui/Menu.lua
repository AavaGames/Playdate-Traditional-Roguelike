local gfx <const> = playdate.graphics

class("Menu").extends()

function Menu:init(manager, name, items)
    print ("Menu created with " .. #items .. " items.")
    self.items = items
    self.font = screenManager.logFont_8px

    self.manager = manager
    self.name = name

    self.kbOpen = false
    self.kbInput = ""

    self.byteStart = 64 -- "A"
end

function Menu:addItem()
    
end

function Menu:update()
    if (not self.kbOpen) then
        if (inputManager:JustPressed(playdate.kButtonA)) then
            self:openKeyboard()
        elseif (inputManager:JustPressed(playdate.kButtonB)) then
            self.manager:removeMenu()
        end
    end
end

function Menu:draw()
    gfx.clear(gfx.kColorBlack)
   
    gfx.setFont(self.font.font)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    gfx.drawTextAligned(self.name, 100, 2, kTextAlignment.center)
    gfx.drawTextAligned("A - Open KB\nB - Close Menu", screenManager.screenDimensions.x, 
        screenManager.screenDimensions.y - self.font.size*4, kTextAlignment.right)

    local text = ""
    for i = 1, #self.items, 1 do
        text = text .. string.char(self.byteStart + i) .. ": " .. self.items[i].text .. "\n"
    end

    local x = 5
    local y = 20
    gfx.drawText(text, x, y)
end

function Menu:setActive()
    self:openKeyboard()
end

function Menu:openKeyboard()
    print("show")
    playdate.keyboard.show()
    playdate.keyboard.textChangedCallback = function() self:readKeyboard() end
    playdate.keyboard.keyboardDidHideCallback = function () self:keyboardHidden() end
    self.kbOpen = true
end

function Menu:readKeyboard()
    self.kbInput = playdate.keyboard.text
    playdate.keyboard.hide()
end

function Menu:keyboardHidden()
    self.kbOpen = false

    local input = self.kbInput
    if (input ~= nil and input ~= "") then
        local char = string.byte(input)
        local index = char - self.byteStart
        if (index >= 1 and index <= #self.items) then
            local item = self.items[index]
            item.func()
            if (item.closeMenuOnExecution == true) then
                self.manager:removeMenu()
            end
        end
        print(self.name .. ": " .. input)
    end

    self.kbInput = nil

end