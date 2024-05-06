---@class MenuItem
---@overload fun(text: string, assignedGlyph, closeKeyboardOnSelect: boolean, closeMenuOnSelect: boolean, allMenus: boolean, selectionFunction: function): MenuItem
MenuItem = class("MenuItem").extends() or MenuItem

local ExecutionBehaviors <const> = enum.new({"Nothing", "CloseMenuOnSelect", "CloseAllMenus"})

--[[
    Initializes a menu item.

    Parameters:
        text (string): The text of the menu item.
        assignedGlyph (string): The preferred assigned glyph for the menu item. Nil assigns the next in the keyboard sequence. First come, first serve. To skip use nil or empty string ""
        closeKeyboardOnSelect (boolean): Whether to close the keyboard on selection.
        closeMenuOnSelect (boolean): Whether to close the menu on selection.
        allMenus (boolean): Whether to close all menus on selection. Requires closeMenuOnSelect.
        selectionFunction (function): The function to execute when the menu item is selected.
]]
function MenuItem:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    if assignedGlyph == "" then assignedGlyph = nil end
    if assignedGlyph ~= nil and string.len(assignedGlyph) > 1 then
        assignedGlyph = string.sub(assignedGlyph, 1, 1)
    end

    self.baseText = text
    self.text = self.baseText
    self.assignedGlyph = assignedGlyph
    self.closeKeyboardOnSelect = closeMenuOnSelect == true and true or closeKeyboardOnSelect
    self.ExecutionBehaviors = ExecutionBehaviors
    if (closeKeyboardOnSelect and closeMenuOnSelect) then
        if (allMenus) then
            self.executionBehavior = self.ExecutionBehaviors.CloseAllMenus
        else
            self.executionBehavior = self.ExecutionBehaviors.CloseMenuOnSelect
        end
    else
        self.executionBehavior = self.ExecutionBehaviors.Nothing
    end
    self.selectionFunction = selectionFunction
end

function MenuItem:isState(state)
    return self.executionBehavior == state
end

function MenuItem:selected()
    self.selectionFunction()
end