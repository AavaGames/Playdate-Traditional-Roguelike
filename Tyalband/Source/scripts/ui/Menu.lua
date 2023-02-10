local gfx <const> = playdate.graphics

class("Menu").extends()

local charByteStart <const> = 65 -- "A"
-- can add an alternate char set for the left side of the keyboard

function Menu:init(manager, name, items, subMenuCount)
    self.manager = manager
    self.name = name
    self.font = screenManager.logFont_8px

    self.itemTextDimensions = {
        x = 4,
        y = 18,
        width = screenManager.screenDimensions.x - 10,
        height = screenManager.screenDimensions.y - self.font.size * 6,
    }

    self.items = {}
    self.subMenu = nil
    self.subMenuCount = subMenuCount or 1

    self.kbInput = nil

    self:populateItems(items)
end

function Menu:update()
    if (not playdate.keyboard.isVisible()) then
        if (inputManager:justPressed(playdate.kButtonA)) then
            self:openKeyboard()
        elseif (inputManager:justPressed(playdate.kButtonB)) then
            self.manager:removeMenu()
        end
    else
        if (inputManager:justPressed(playdate.kButtonB)) then
            self:closeKeyboard()
        end
        screenManager:redrawMenu()
    end
end

function Menu:draw()
    gfx.clear(gfx.kColorBlack)

    gfx.setFont(self.font.font)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    -- Name Text
    local name = self.name
    if (self.subMenuCount > 1) then
        name = name .. " pg." .. self.subMenuCount
    end
    gfx.drawTextAligned(name, 200, 1, kTextAlignment.center)
    -- Input Text
    gfx.drawTextAligned("A - Open KB\nB - Close Menu", screenManager.screenDimensions.x, 
        screenManager.screenDimensions.y - self.font.size * 4, kTextAlignment.right)

    -- Menu Items Text
    gfx.drawTextInRect(self:getFullItemText(), self.itemTextDimensions.x, self.itemTextDimensions.y, 
                    self.itemTextDimensions.width, self.itemTextDimensions.height)
end

function Menu:populateItems(items)
    local itemNeedsChar = {}
    -- check if item already has pre-assigned character
    for index, item in ipairs(items) do
        -- check if assignment is already taken
        if (item.assignedChar ~= nil and self.items[item.assignedChar] == nil) then
            if (self:checkForSubMenu(index, item, items)) then
                items = nil
                break
            else
                self.items[item.assignedChar] = item
                table.insert(itemNeedsChar, false)
            end
        else
            table.insert(itemNeedsChar, true)
        end
    end
    -- Alphabetic Char assignment
    local currentByte = charByteStart
    for index, item in ipairs(items) do
        if (itemNeedsChar[index]) then
            local char = string.char(currentByte)
            while self.items[char] ~= nil do
                currentByte += 1
            end

            if (self.items[char] == nil) then
                if (self:checkForSubMenu(index, item, items)) then
                    items = nil
                    break
                else
                    item.assignedChar = char
                    self.items[item.assignedChar] = item
                end
            end
            currentByte += 1
        end
    end

    local count = 0
    for key, value in pairs(self.items) do
        count += 1
    end
    --pDebug:log("Menu: " .. self.name .. " created with " .. count .. " items.")
end

function Menu:checkForSubMenu(index, item, items)
    gfx.setFont(self.font.font)
    local text = self:getFullItemText(item)
    local textwidth, textHeight = gfx.getTextSizeForMaxWidth(text, self.itemTextDimensions.width)
    if (textHeight > self.itemTextDimensions.height) then
        local subItems = {}
        for i = index, #items, 1 do
            table.insert(subItems, items[i])
        end
        self.subMenu = Menu(self.manager, self.name, subItems, self.subMenuCount + 1)

        local char = "a"
        self.items[char] = MenuItem("...", char, true, false, false, function ()
            self.manager:addMenu(self.subMenu)
        end)

        return true
    end
end

function Menu:addItem(item, assignedChar)
    item.assignedChar = assignedChar
    self.items[item.assignedChar] = item
    -- check if submenu
end

function Menu:removeItem(index)
    if (index ~= nil and not math.inBoundsOfArray(index, #self.items)) then
        index = nil
        pDebug:error(self.name .. " remove Item index out of bounds") -- TODO error catch?
    end
    table.remove(self.items, index or #self.items) -- remove index or the last item
end

function Menu:getFullItemText(extraItem)
    local text = ""
    if (extraItem) then 
        text = "M" .. ": " .. extraItem.text .. "\n"
    end
    for key, item in pairsByKeys(self.items) do
        text = text .. key .. ": " .. item.text .. "\n"
    end
    return text
end

function Menu:setActive()
    --pDebug:log(self.name .. " set active")
    screenManager:redrawScreen()
    -- Opening kb here results in a loop bug
    -- guessing kb doesn't turn off visible before callback
end

function Menu:setInactive()
    --pDebug:log(self.name .. " set inactive")
    self.kbInput = nil
    self:closeKeyboard()
end

function Menu:openKeyboard()
    playdate.keyboard.show()
    playdate.keyboard.textChangedCallback = function() self:readKeyboard() end
end

function Menu:closeKeyboard()
    playdate.keyboard.hide()
    playdate.keyboard.textChangedCallback = function() end
end

function Menu:readKeyboard()
    local input = playdate.keyboard.text
    self.kbInput = nil
    if (input ~= nil and input ~= "") then
        if (self.items[input] ~= nil) then
            --pDebug:log(self.name .. ": " .. input)
            self.kbInput = input
            local closeKB = self.items[self.kbInput].closeKeyboardOnSelect
            if (closeKB) then
                self:closeKeyboard()
            end
            self:selectItem()
        else
            pDebug:log(input .. " out of bounds")
        end
    end
    playdate.keyboard.text = ""

end

function Menu:selectItem()
    if (self.kbInput ~= nil) then
        local item = self.items[self.kbInput]
        item:selected()
        if (item:isState(item.executionBehaviors.closeAllMenus)) then
            self.manager:removeAllMenu()
        elseif (item:isState(item.executionBehaviors.closeMenuOnSelect)) then
            self.manager:removeMenu()
        end
    end
    self.kbInput = nil
end