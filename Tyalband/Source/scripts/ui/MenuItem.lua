class("MenuItem").extends()

local ExecutionBehaviors <const> = enum.new({"Nothing", "CloseMenuOnSelect", "CloseAllMenus"})

function MenuItem:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.baseText = text
    self.text = self.baseText
    self.assignedGlyph = assignedGlyph
    self.closeKeyboardOnSelect = closeKeyboardOnSelect
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