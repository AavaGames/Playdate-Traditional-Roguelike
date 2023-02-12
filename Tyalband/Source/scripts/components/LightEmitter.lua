class("LightEmitter").extends(Component)

function LightEmitter:init()
    self.brightRange = 2
    self.dimRange = 4
    self.lightSources = {}
end

function LightEmitter:attach(entity)
    LightEmitter.super.attach(self, entity)
end

function LightEmitter:detatch(entity)
    LightEmitter.super.detatch(self, entity)
end

function LightEmitter:addLightSource(source)
    -- TODO rework to take into consideration EQUIPMENT TYPE (Sword, Lantern, etc.)
    isComponent(source)
    self.lightSources[source.className] = source
    self:calculateLightRange()
end

function LightEmitter:removeLightSource(source)
    self.lightSources[source.className] = nil
end

function LightEmitter:calculateLightRange()
    self.brightRange, self.dimRange = 0, 0
    for key, source in pairs(self.lightSources) do
        self.brightRange += source.brightRange
        self.dimRange += source.dimRange
    end
end

function LightEmitter:largestRange()
    return self.brightRange > self.dimRange and self.brightRange or self.dimRange
end