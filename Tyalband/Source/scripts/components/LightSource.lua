class("LightSource").extends(Component)

function LightSource:init(brightRange, dimRange)
    self.brightRange = brightRange or 0
    self.dimRange = dimRange or 0
end

function LightSource:attach(entity)
    LightSource.super.attach(self, entity)
end

function LightSource:detatch(entity)
    LightSource.super.detatch(self, entity)
end

function LightSource:addToEmitter()
    if (not self.entity:hasComponent(LightEmitter)) then
        print("has no emitter")
        --self.entity:addComponent(LightEmitter())
    end
    local emitter = self.entity:getComponent(LightEmitter)
    emitter:addLightSource(self)
end

function LightSource:removeFromEmitter()
    self.entity:getComponent(LightEmitter):removeLightSource(self)
end