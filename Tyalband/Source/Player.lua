class("Player").extends(Actor)

function Player:init(theLevel, startPosition)
    Player.super.init(self, theLevel, startPosition)
    self.char = "@"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful!"

    self.moveDir = { x = 0, y = 0 }
    self.state = INACTIVE

    self.visionRange = 4

    self.equipped = {
        lightSource = nil
    }

    self.equipped.lightSource = LightSource()
    self.equipped.lightSource.name = "Lantern"

    self.kb = false
    local menu = playdate.getSystemMenu()
    local inventoryMenu, error = menu:addMenuItem("Inventory", function()
        print("inventory opened")
        self.state = INACTIVE
        self.kb = true
        playdate.keyboard.show()
    end)
    playdate.keyboard.textChangedCallback = function() self:inventoryUse() end
end

function Player:update()
    if self.kb then 
        if not playdate.keyboard.isVisible() then
            self.state = ACTIVE
            self.kb = false
        end
    end

    if (self.state == ACTIVE) then
        self.moveDir = Vector2.zero()
        local actionTaken = false

        if inputManager:JustReleased(playdate.kButtonRight) then
            self.moveDir.x += 1
        end
        if inputManager:JustReleased(playdate.kButtonLeft) then
            self.moveDir.x -= 1
        end
        if inputManager:JustReleased(playdate.kButtonUp) then
            self.moveDir.y -= 1
        end
        if inputManager:JustReleased(playdate.kButtonDown) then
            self.moveDir.y += 1
        end

        if (self.moveDir ~= Vector2.zero()) then
            if self:move(self.moveDir) then
                actionTaken = true
            end
        end

        if actionTaken then
            self.level:round()
        end
    end
end

function Player:tick()
    Player.super.tick(self)
end

function Player:inventoryUse()
    -- parse inventory
    print("picked: " .. playdate.keyboard.text)

    playdate.keyboard.hide()
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
        print("SPAWNING ERROR: ", theLevel.name, startPosition, " parameters failed to find appropriate location.")
    end
end

function Player:despawn()
    self.state = INACTIVE
end