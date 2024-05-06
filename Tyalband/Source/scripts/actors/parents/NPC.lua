---@class NPC
---@overload fun(theLevel: Level, startPosition: Vector2): NPC
NPC = class("NPC").extends(Actor) or NPC

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