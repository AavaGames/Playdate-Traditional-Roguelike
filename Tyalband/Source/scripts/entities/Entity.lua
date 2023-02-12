local gfx <const> = playdate.graphics

class("Entity").extends()

--abstract class
function Entity:init()
    self.glyph = "!"
    self.name = "Entity"
    self.description = "An entity which exists in the level."

    self.components = {} -- make it a set?
end

-- Add the initalized component to the entity
function Entity:addComponent(component)
    isComponent(component)
    if (self.components[component.className] ~= nil) then
        pDebug.log("Entity: " .. self.name .. " overwritting " .. component.className .. " component")
    end

    component:attach(self)
    self.components[component.className] = component

    if (self.components[component.className] == nil) then
        pDebug.error("Entity: " .. self.name .. " failed to add " .. component)
    end
end

function Entity:removeComponent(component)
    isComponent(component)
    if (self:hasComponent(component)) then
        component:detatch(self)
    end
    self.components[component.className] = nil
end

function Entity:getComponent(component)
    isComponent(component)
    return self.components[component.className] or nil
end

function Entity:hasComponent(component)
    isComponent(component)
    return self.components[component.className] ~= nil
end