-- ---@class Template : Component
-- ---@overload fun(): Template
-- Template = class("Template").extends(Component) or Template

function Template:init()
    Template.super.init(self)
end

function Template:attach(entity)
    Template.super.attach(self, entity) -- do first

end

function Template:detatch(entity)

    Template.super.detatch(self, entity) -- do last
end