-- ---@class Template : Item
-- ---@overload fun(actor: Actor): Template
-- Template = class("Template").extends(Item) or Template

function Template:init(actor)
    Template.super.init(self, actor)

end


-- Super Functions (Remove Unused)

function Template:pickup(actor)
    Template.super.pickup(self, actor)
end

function Template:remove(actor)
    Template.super.remove(self, actor)
end

function Template:drop(actor)
    Template.super.drop(self, actor)
end

function Template:inspect()
    Template.super.inspect(self)
end

function Template:use()
    Template.super.use(self)
end

function Template:throw()
    Template.super.throw(self)
end

function Template:hit(damageStats)
    Template.super.hit(self, damageStats)
end

function Template:destroy()
    Template.super.destroy(self)
end