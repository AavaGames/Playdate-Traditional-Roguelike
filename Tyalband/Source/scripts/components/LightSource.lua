class("LightSource").extends(Component)

function LightSource:init(brightRange, dimRange)
    LightSource.super.init(self)
    self.brightRange = brightRange or 0
    self.dimRange = dimRange or 0
end

-- Adds / Creates then adds to its entity or the one given
function LightSource:addToEmitter(entity)
    local entity = entity or self.entity
    if (not entity:hasComponent(LightEmitter)) then
        entity:addComponent(LightEmitter())
        print("has no emitter")
    end
    entity:getComponent(LightEmitter):addLightSource(self)
end

function LightSource:removeFromEmitter(entity)
    if (entity:hasComponent(LightEmitter)) then
        entity:getComponent(LightEmitter):removeLightSource(self)
    end
end