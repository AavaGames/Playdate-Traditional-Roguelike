class("Template").extends(Actor)

function Template:init(theLevel, startPosition)
    Template.super.init(self, theLevel, startPosition)
    self.glyph = "#"
    self.name = "Actor"
    self.description = "A nice individual."
end

function Template:round()
    Template.super.round(self)
end