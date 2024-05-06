---@class MenuItemOptions
---@overload fun(): MenuItemOptions
MenuItemOptions = class("MenuItemOptions").extends(MenuItem) or MenuItemOptions

function MenuItemOptions:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, options, startingIndex, selectionFunction)
    MenuItemOptions.super.init(self, text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.options = options
    self.currentIndex = startingIndex
    self:updateText()
end

function MenuItemOptions:updateText()
    local option = "<" .. self.options[self.currentIndex] .. ">"
    self.text = self.baseText .. " " .. option
end

function MenuItemOptions:selected()
    self.currentIndex = math.loopIndexOfArray(self.currentIndex + 1, #self.options)
    self.selectionFunction(self.options[self.currentIndex])
    self:updateText()
    screenManager:redrawMenu()
end