local gfx <const> = playdate.graphics

class("Menu").extends()

local charByteStart <const> = 65 -- "A"
-- can add an alternate char set for the left side of the keyboard

function Menu:init(manager, name, items)

    local t = ChunkTimer("Create " .. name)
    self.manager = manager
    self.name = name
    self.font = screenManager.logFont_8px

    self.itemTextDimensions = {
        x = 4,
        y = 18,
        width = screenManager.screenDimensions.x - 10,
        height = screenManager.screenDimensions.y - self.font.size * 6,
    }

    gfx.setFont(self.font.font)

    self.items = {}
    self.subMenu = nil

    self.kbOpen = false
    self.kbInput = nil

    self:populateItems(items)
    t:print()
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
    print ("Menu: " .. self.name .. " created with " .. count .. " items.")
end

function Menu:checkForSubMenu(index, item, items)
    local text = self:getFullItemText(item)
    local textwidth, textHeight = gfx.getTextSizeForMaxWidth(text, self.itemTextDimensions.width)
    if (textHeight > self.itemTextDimensions.height) then
        local subItems = {}
        for i = index, #items, 1 do
            table.insert(subItems, items[i])
        end
        self.subMenu = Menu(self.manager, self.name, subItems)

        local char = "a"
        self.items[char] = MenuItem("...", char, false, false, function ()
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
        print(self.name .. " ERROR: remove Item index out of bounds") -- TODO error catch?
    end
    table.remove(self.items, index or #self.items) -- remove index or the last item
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

    -- Name Text
    gfx.drawTextAligned(self.name, 200, 1, kTextAlignment.center)
    -- Input Text
    gfx.drawTextAligned("A - Open KB\nB - Close Menu", screenManager.screenDimensions.x, 
        screenManager.screenDimensions.y - self.font.size * 4, kTextAlignment.right)

    gfx.drawTextInRect(self:getFullItemText(), self.itemTextDimensions.x, self.itemTextDimensions.y, 
                    self.itemTextDimensions.width, self.itemTextDimensions.height)
end

function Menu:getFullItemText(extraItem)
    local text = ""

    if (extraItem) then 
        text = "A" .. ": " .. extraItem.text .. "\n"
    end

    for key, item in pairsByKeys(self.items) do
        text = text .. key .. ": " .. item.text .. "\n"
    end
    return text
end

function Menu:setActive()
    print(self.name .. " set active")
    -- Opening kb here results in a loop bug
    -- guessing kb doesn't turn off visible before callback
end

function Menu:openKeyboard()
    print("show menu")
    playdate.keyboard.show()
    playdate.keyboard.textChangedCallback = function() self:readKeyboard() end
    playdate.keyboard.keyboardDidHideCallback = function () self:keyboardHidden() end
    self.kbOpen = true
end
function Menu:readKeyboard()
    local input = playdate.keyboard.text
    self.kbInput = nil
    if (input ~= nil and input ~= "") then
        if (self.items[input] ~= nil) then
            print(self.name .. ": " .. input)
            self.kbInput = input
            playdate.keyboard.hide()
        else
            print(input .. " out of bounds")
        end
    end
    playdate.keyboard.text = ""
end

function Menu:keyboardHidden()
    if (self.kbOpen == true) then
        self.kbOpen = false

        if (self.kbInput ~= nil) then
            local item = self.items[self.kbInput]
            item.selectionFunction()

            if (item:isState(item.executionBehaviors.closeAllMenus)) then
                self.manager:removeAllMenu()
            elseif (item:isState(item.executionBehaviors.closeMenu)) then
                self.manager:removeMenu()
            end
        end
    end
    playdate.keyboard.textChangedCallback = function() end
    playdate.keyboard.keyboardDidHideCallback = function () end
    self.kbInput = nil
end