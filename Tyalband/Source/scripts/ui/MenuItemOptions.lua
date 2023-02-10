class("MenuItemOptions").extends(MenuItem)

function MenuItemOptions:init(text, assignedChar, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, options, startingIndex, selectionFunction)
    MenuItemOptions.super.init(self, text, assignedChar, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
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