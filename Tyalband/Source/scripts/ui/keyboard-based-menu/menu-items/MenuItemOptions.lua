---@class MenuItemOptions: MenuItem
---@overload fun(text: string, assignedGlyph, closeKeyboardOnSelect: boolean, closeMenuOnSelect: boolean, allMenus: boolean, options: table, startingIndex: number, selectionFunction: function): MenuItemOptions
MenuItemOptions = class("MenuItemOptions").extends("MenuItem") or MenuItemOptions

--[[
    Initializes an options menu item.

    Parameters:
        text (string): The text of the menu item.
        assignedGlyph (string): The preferred assigned glyph for the menu item. Nil assigns the next in the keyboard sequence. First come, first serve.
        closeKeyboardOnSelect (boolean): Whether to close the keyboard on selection.
        closeMenuOnSelect (boolean): Whether to close the menu on selection.
        allMenus (boolean): Whether to close all menus on selection. Requires closeMenuOnSelect.
        options (table): The available options for the menu item.
        startingIndex (number): The starting index of the selected option.
        selectionFunction (function): The function to execute when the menu item is selected. Requires option parameter.
]]
function MenuItemOptions:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, options, startingIndex, selectionFunction)
    MenuItemOptions.super.init(self, text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.options = options
    if (startingIndex > #options) then
        error("starting option index is larger than options count.")
    end
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