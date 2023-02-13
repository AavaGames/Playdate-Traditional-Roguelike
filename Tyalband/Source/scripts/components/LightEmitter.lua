class("LightEmitter").extends(Component)

function LightEmitter:init(baseBrightRange, baseDimRange)
    LightEmitter.super.init(self)
    self.baseBrightRange = baseBrightRange or 0
    self.baseDimRange = baseDimRange or 0
    self.brightRange = self.baseBrightRange
    self.dimRange = self.baseDimRange
    self.lightSources = {}
end

function LightEmitter:attach(entity)
    LightEmitter.super.attach(self, entity)
end

function LightEmitter:detatch(entity)
    LightEmitter.super.detatch(self, entity)
end

function LightEmitter:addLightSource(source)
    -- TODO rework to take into consideration EQUIPMENT TYPE (Sword, Lantern, etc.) rather than className
    -- TODO add to level so that to loop you
    isObjectError(source, LightSource)
    self.lightSources[source.className] = source
    self:calculateLightRange()
end

function LightEmitter:removeLightSource(source)
    self.lightSources[source.className] = nil
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