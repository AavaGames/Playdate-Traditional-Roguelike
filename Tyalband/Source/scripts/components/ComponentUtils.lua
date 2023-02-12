
function isComponent(component)
    if (not component:isa(Component)) then pDebug.error(component, "is not a component") end
end