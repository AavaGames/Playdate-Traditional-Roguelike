class("MenuItemBool").extends(MenuItem)

function MenuItemBool:init(text, assignedChar, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, startingValue, selectionFunction)
    MenuItemBool.super.init(self, text, assignedChar, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.bool = startingValue
end

function MenuItemBool:getText()
    local bool = self.bool == true and "<ON>" or "<OFF>"
    return self.text .. " " .. bool
end

function MenuItemBool:selected()
    self.bool = not self.bool
    self.selectionFunction(self.bool)

    screenManager:redrawMenu()
end