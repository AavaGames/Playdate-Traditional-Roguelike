
function isObjectError(object, class)
    if object ~= nil then
        if (not object:isa(class)) then pDebug.error(object, "is not a " .. class.className) end
        return object:isa(class)
    end
    return false
end

function isComponent(component)
    return component:isa(Component)
end

