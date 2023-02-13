--[[
    An entity is any world object (Actor, Player, Feature, Item, Equipable, etc.) they can hold components.
    Only ONE component of each class.
]]

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
    isObjectError(component, Component)
    if (self.components[component.className] ~= nil) then
        pDebug.log("Entity: " .. self.name .. " overwritting " .. component.className .. " component")
    end

    if (component.attach ~= nil) then
        component:attach(self)
    else
        pDebug.error("Entity: " .. self.name .. " component has no attach function " .. component)
    end

    self.components[component.className] = component
    return self.components[component.className]
end

function Entity:removeComponent(component)
    isObjectError(component, Component)
    if (self:hasComponent(component)) then
        component:detatch(self)
    end
    self.components[component.className] = nil
end

function Entity:getComponent(component)
    isObjectError(component, Component)
    return self.components[component.className] or nil
end

function Entity:hasComponent(component)
    isObjectError(component, Component)
    return self.components[component.className] ~= nil
end