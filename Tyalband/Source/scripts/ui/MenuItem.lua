class("MenuItem").extends()

function MenuItem:init(text, assignedChar, closeMenu, allMenus, selectionFunction)
    self.text = text
    self.assignedChar = assignedChar
    self.executionBehaviors = enum({"nothing", "closeMenu", "closeAllMenus"})
    if (closeMenu) then
        if (allMenus) then
            self.executionBehavior = closeMenu and self.executionBehaviors.closeAllMenus
        else
            self.executionBehavior = closeMenu and self.executionBehaviors.closeMenu
        end
    else
        self.executionBehavior = closeMenu and self.executionBehaviors.nothing
    end
    self.selectionFunction = selectionFunction
end

function MenuItem:isState(state)
    return self.executionBehavior == state
end