--[[
    A component is attached to an entity, the entity will run a loop on its components when it acts within its Round().
        Indexed to a table by its class name, this means that the entity can only have one TYPE of component at a time.
]]

class("Component").extends()

function Component:init(entity)
    self.entity = entity
end

function Component:attach(entity)
    self.entity = entity
end

function Component:detatch(entity)
    self.entity = nil
end