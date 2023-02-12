class("Template").extends(Component)

function Template:init()

end

function Template:attach(entity)
    Template.super.attach(self, entity) -- do first

end

function Template:detatch(entity)

    Template.super.detatch(self, entity) -- do last
end