---@class Menu : Object
---@overload fun(menuManager, name: string, font, items: table, subMenuCount?: integer): Menu
Menu = class("Menu").extends() or Menu

local gfx <const> = playdate.graphics

local charByteStart <const> = 65 -- "A"

--[[
    Initializes a menu.

    Parameters:
        menuManager (object): The menu manager object.
        name (string): The name of the menu. Shown at the top of the menu
        items (table): A table containing the items of the menu.
        subMenuCount (number): The sub menu number. Should not be set, used internally by the menu itself when creating pages.
]]
function Menu:init(menuManager, name, font, items, subMenuCount)
    self.menuManager = menuManager
    self.name = name
    self.font = font == nil and gfx.getFont() or font

    -- If you'd like to change the padding, tweak these numbers
    self:SetPadding(4, 4)

    self.items = {}
    self.subMenu = nil
    self.subMenuCount = subMenuCount or 1

    -- used to ignore inputs on first frame of opening
    self.justOpened = false
    self.kbInput = nil

    self:populateItems(items)
end

function Menu:SetPadding(horizontalPadding, verticalPadding)
    self.itemTextDimensions = {
        x = horizontalPadding,
        y = self.font:getHeight() + verticalPadding,
        width = self.menuManager.screenWidth - (horizontalPadding * 2),
        height = self.menuManager.screenHeight - self.font:getHeight() * 2,
    }
end

function Menu:update()
    if (self.justOpened) then
        self.justOpened = false
        return
    end

    if (not playdate.keyboard.isVisible()) then
        if (playdate.buttonJustPressed(playdate.kButtonA)) then
            self:openKeyboard()
        elseif (playdate.buttonJustPressed(playdate.kButtonB)) then
            self.menuManager:removeMenu()
        end
    else
        if (playdate.buttonJustPressed(playdate.kButtonB)) then
            self:closeKeyboard()
        end
        screenManager:redrawMenu()
    end
end

function Menu:draw()
    gfx.clear(self.menuManager.backgroundColor)

    local oldFont = gfx.getFont()
    gfx.setFont(self.font)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    -- Name Text
    local name = self.name
    if (self.subMenuCount > 1) then
        name = name .. " pg." .. self.subMenuCount
    end
    gfx.drawTextAligned(name, 200, 1, kTextAlignment.center)
    -- Input Text
    local inputText = "Open KB - A\nClose " .. (self.subMenuCount > 1 and "Page" or "Menu") .. " - B"
    gfx.drawTextAligned(inputText, self.menuManager.screenWidth,
        self.menuManager.screenHeight - self.font:getHeight() * 2, kTextAlignment.right)

    -- Menu Items Text
    gfx.drawTextInRect(self:getFullItemText(), self.itemTextDimensions.x, self.itemTextDimensions.y,
        self.itemTextDimensions.width, self.itemTextDimensions.height)

    gfx.setFont(oldFont)
end

function Menu:populateItems(items)
    local oldFont = gfx.getFont()
    gfx.setFont(self.font)

    local itemNeedsGlyph = {}
    -- check if item already has pre-assigned Glyph
    for index, item in ipairs(items) do
        -- check if assignment is already taken
        if (item.assignedGlyph ~= nil and self.items[item.assignedGlyph] == nil) then
            if (self:checkForSubMenu(index, item, items)) then
                items = nil
                break
            else
                self.items[item.assignedGlyph] = item
                table.insert(itemNeedsGlyph, false)
            end
        else
            table.insert(itemNeedsGlyph, true)
        end
    end
    -- Alphabetic Glyph assignment
    local currentByte = charByteStart
    for index, item in ipairs(items) do
        if (itemNeedsGlyph[index]) then
            local glyph = string.char(currentByte)
            while self.items[glyph] ~= nil do
                currentByte += 1
                glyph = string.char(currentByte)
            end

            if (self.items[glyph] == nil) then
                if (self:checkForSubMenu(index, item, items)) then
                    items = nil
                    break
                else
                    item.assignedGlyph = glyph
                    self.items[item.assignedGlyph] = item
                end
            end
            currentByte += 1
        end
    end

    gfx.setFont(oldFont)
end

function Menu:checkForSubMenu(index, item, items)
    local text = self:getFullItemText(item)
    local textwidth, textHeight = gfx.getTextSizeForMaxWidth(text, self.itemTextDimensions.width)
    if (textHeight > self.itemTextDimensions.height) then
        local subItems = {}
        for i = index, #items, 1 do
            table.insert(subItems, items[i])
        end
        self.subMenu = Menu(self.menuManager, self.name, self.font, subItems, self.subMenuCount + 1)

        local glyph = "a"
        self.items[glyph] = MenuItem("...", glyph, true, false, false, function ()
            self.menuManager:addMenu(self.subMenu)
        end)

        return true
    end
end

function Menu:getFullItemText(extraItem)
    local text = ""
    if (extraItem) then 
        text = "M" .. ": " .. extraItem.text .. "\n"
    end
    for key, item in math.pairsByKeys(self.items) do
        text = text .. key .. ": " .. item.text .. "\n"
    end
    return text
end

function Menu:open()
    self.menuManager:addMenu(self)
end

function Menu:setActive()
    self.justOpened = true
    screenManager:redrawScreen()
end

function Menu:setInactive()
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
            self.kbInput = input
            local closeKB = self.items[self.kbInput].closeKeyboardOnSelect
            if (closeKB) then
                self:closeKeyboard()
            end
            self:selectItem()
        else
            --print(input .. " out of bounds")
        end
    end
    playdate.keyboard.text = ""
end

function Menu:selectItem()
    if (self.kbInput ~= nil) then
        local item = self.items[self.kbInput]
        item:selected()
        if (item:isState(item.ExecutionBehaviors.CloseAllMenus)) then
            self.menuManager:removeAllMenu()
        elseif (item:isState(item.ExecutionBehaviors.CloseMenuOnSelect)) then
            self.menuManager:removeMenu()
        end
    end
    self.kbInput = nil
end