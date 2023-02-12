class("MenuItemBool").extends(MenuItem)

function MenuItemBool:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, startingValue, selectionFunction)
    MenuItemBool.super.init(self, text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.bool = startingValue
    self:updateText()
end

function MenuItemBool:updateText()
    local bool = self.bool == true and "<ON>" or "<OFF>"
    self.text = self.baseText .. " " .. bool
end

function MenuItemBool:selected()
    self.bool = not self.bool
    self.selectionFunction(self.bool)
    self:updateText()
    screenManager:redrawMenu()
end