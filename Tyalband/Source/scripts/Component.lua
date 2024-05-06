---@class Component
---@overload fun(): Component
Component = class("Component").extends() or Component

--[[
    A component is attached to an entity, the entity will run a loop on its components when it acts within its Round().
        Indexed to a table by its class name, this means that the entity can only have one TYPE of component at a time.
]]
function Component:init()
    self.entity = nil
end

function Component:attach(entity)
    isObjectError(entity, Entity)
    self.entity = entity
end

function Component:detatch(entity)
    self.entity = nil
end