---@class MenuItemBool: MenuItem
---@overload fun(text: string, assignedGlyph, closeKeyboardOnSelect: boolean, closeMenuOnSelect: boolean, allMenus: boolean, startingValue: boolean, selectionFunction: function): MenuItemBool
MenuItemBool = class("MenuItemBool").extends(MenuItem) or MenuItemBool

--[[
    Initializes a boolean menu item.

    Parameters:
        text (string): The text of the menu item.
        assignedGlyph (string): The preferred assigned glyph for the menu item. Nil assigns the next in the keyboard sequence. First come, first serve.
        closeKeyboardOnSelect (boolean): Whether to close the keyboard on selection.
        closeMenuOnSelect (boolean): Whether to close the menu on selection.
        allMenus (boolean): Whether to close all menus on selection. Requires closeMenuOnSelect.
        startingValue (boolean): The starting value of the boolean menu item.
        selectionFunction (function): The function to execute when the menu item is selected.
]]
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