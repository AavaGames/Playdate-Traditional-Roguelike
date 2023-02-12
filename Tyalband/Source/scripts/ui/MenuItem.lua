class("MenuItem").extends()

function MenuItem:init(text, assignedGlyph, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.baseText = text
    self.text = self.baseText
    self.assignedGlyph = assignedGlyph
    self.closeKeyboardOnSelect = closeKeyboardOnSelect
    self.executionBehaviors = enum({"nothing", "closeMenuOnSelect", "closeAllMenus"})
    if (closeKeyboardOnSelect and closeMenuOnSelect) then
        if (allMenus) then
            self.executionBehavior = self.executionBehaviors.closeAllMenus
        else
            self.executionBehavior = self.executionBehaviors.closeMenuOnSelect
        end
    else
        self.executionBehavior = self.executionBehaviors.nothing
    end
    self.selectionFunction = selectionFunction
end

function MenuItem:isState(state)
    return self.executionBehavior == state
end

function MenuItem:selected()
    self.selectionFunction()
end