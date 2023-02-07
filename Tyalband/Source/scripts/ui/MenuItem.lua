class("MenuItem").extends()

function MenuItem:init(text, assignedChar, closeKeyboardOnSelect, closeMenuOnSelect, allMenus, selectionFunction)
    self.text = text
    self.assignedChar = assignedChar
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

function MenuItem:getText()
    return self.text
end

function MenuItem:selected()
    self.selectionFunction()
end