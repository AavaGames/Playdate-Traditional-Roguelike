---@class LightEmitter
---@overload fun(baseBrightRange: integer, baseDimRange: integer): LightEmitter
LightEmitter = class("LightEmitter").extends(Component) or LightEmitter

function LightEmitter:init(baseBrightRange, baseDimRange)
    LightEmitter.super.init(self)
    self.baseBrightRange = baseBrightRange or 0
    self.baseDimRange = baseDimRange or 0
    self.brightRange = self.baseBrightRange
    self.dimRange = self.baseDimRange
    self.lightSources = {}
end

function LightEmitter:addLightSource(source, slot)
    -- TODO add to level for the lighting loop
    isObjectError(source, LightSource)
    self.lightSources[source.entity.name] = source
    self:calculateLightRange()
end

function LightEmitter:removeLightSource(source)
    self.lightSources[source.entity.name] = nil
    self:calculateLightRange()
end

function LightEmitter:calculateLightRange()
    self.brightRange, self.dimRange = self.baseBrightRange, self.baseDimRange
    for key, source in pairs(self.lightSources) do
        self.brightRange += source.brightRange
        self.dimRange += source.dimRange
    end
end

function LightEmitter:largestRange()
    return self.brightRange > self.dimRange and self.brightRange or self.dimRange
end