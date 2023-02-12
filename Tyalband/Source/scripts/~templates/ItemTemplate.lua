class("Template").extends(Item)

function Template:init(actor)
    Template.super.init(self, actor)

end

function Template:pickup(actor)
    Template.super.pickup(self, actor)
end

function Template:drop(actor)
    Template.super.drop(self, actor)
end

function Template:inspect() end
function Template:use() end
function Template:throw() end