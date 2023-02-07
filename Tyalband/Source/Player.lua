class("Player").extends(Actor)

function Player:init(theLevel, startPosition)
    Player.super.init(self, theLevel, startPosition)
    self.char = "@"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful"

    self.moveDir = { x = 0, y = 0 }
    self.state = INACTIVE

    self.visionRange = 4

    self.equipped = {
        lightSource = nil
    }

    self.equipped.lightSource = LightSource()
    self.equipped.lightSource.name = "Lantern"
end

function Player:update()
    if (self.state == ACTIVE) then
        self.moveDir = Vector2.zero()
        local actionTaken, moved = false, false

        if inputManager:justPressed(playdate.kButtonB) then
            actionTaken = true
        elseif inputManager:justReleased(playdate.kButtonRight) then
            self.moveDir.x += 1
        elseif inputManager:justReleased(playdate.kButtonLeft) then
            self.moveDir.x -= 1
        elseif inputManager:justReleased(playdate.kButtonUp) then
            self.moveDir.y -= 1
        elseif inputManager:justReleased(playdate.kButtonDown) then
            self.moveDir.y += 1
        end

        if (self.moveDir ~= Vector2.zero()) then
            if self:move(self.moveDir) then
                actionTaken, moved = true, true
            end
        end

        if actionTaken then
            self.level:round(moved)
        end
    end
end

function Player:tick()
    Player.super.tick(self)
end

function Player:interact(actor)
    if (actor ~= nil) then
        gameManager.logManager:addToRound("The " .. actor.name .. " bumps into you.")
        actor:interact(self)
    end
end

function Player:spawn(theLevel, startPosition)
    self.position = Vector2.zero()
    self.updated = false
    self.state = ACTIVE

    self.level = theLevel
    self.tile = nil
    if (theLevel ~= nil and startPosition ~= nil) then
        self:moveTo(Vector2.new(startPosition.x, startPosition.y)) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        pDebug:log("SPAWNING ERROR: ", theLevel.name, startPosition, " parameters failed to find appropriate location.")
    end
end

function Player:despawn()
    self.state = INACTIVE
end