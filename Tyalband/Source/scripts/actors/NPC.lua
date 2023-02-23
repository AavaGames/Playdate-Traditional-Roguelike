class("NPC").extends(Actor)

function NPC:init(theLevel, startPosition)
    NPC.super.init(self, theLevel, startPosition)

end

function NPC:interact()

    if (self.currentTarget:isa(Player)) then
        -- display colliding with player text
    end

end

function NPC:attack()
    NPC.super.attack(self)

end