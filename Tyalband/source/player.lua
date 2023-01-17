class("player").extends(actor)

function player:init(theWorld, startPosition)
    player.super.init(self, theWorld, startPosition)
    self.char = "@"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful!"

    self.moveDir = { x = 0, y = 0 }
    self.state = INACTIVE

    self.visionRange = 6

    self.equipped = {
        lightSource = nil
    }

    self.equipped.lightSource = lightSource()
    self.equipped.lightSource.name = "Lantern"

    self.diagonalMove = false
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

function player:update()
    player.super.update(self)

    if self.kb then 
        if not playdate.keyboard.isVisible() then
            self.state = ACTIVE
            self.kb = false
        end
    end

    if (self.state == ACTIVE) then
        self.moveDir = Vector2.zero()
        local actionTaken = false
        -- diagonals are difficult with this movement

        if inputManager:JustPressed(playdate.kButtonB) then
            self.diagonalMove = not self.diagonalMove
        end

        if inputManager:JustReleased(playdate.kButtonRight) then
            self.moveDir.x += 1
            if self.diagonalMove then self.moveDir.y += 1 end
        end
        if inputManager:JustReleased(playdate.kButtonLeft) then
            self.moveDir.x -= 1
            if self.diagonalMove then self.moveDir.y -= 1 end
        end
        if inputManager:JustReleased(playdate.kButtonUp) then
            self.moveDir.y -= 1
            if self.diagonalMove then self.moveDir.x += 1 end
        end
        if inputManager:JustReleased(playdate.kButtonDown) then
            self.moveDir.y += 1
            if self.diagonalMove then self.moveDir.x -= 1 end
        end

        if (self.moveDir ~= Vector2.zero()) then
            if self:move(self.moveDir) then
                actionTaken = true
            end
        end

        if actionTaken then
            self.world:round()
        end
    end
end

function player:inventoryUse()
    -- parse inventory
    print("picked: " .. playdate.keyboard.text)

    playdate.keyboard.hide()
end

function player:spawn(theWorld, startPosition)
    self.position = Vector2.zero()
    self.updated = false
    self.state = ACTIVE

    self.world = theWorld
    self.tile = nil
    if (theWorld ~= nil and startPosition ~= nil) then
        self:moveTo(Vector2.new(startPosition.x, startPosition.y)) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        print("SPAWNING ERROR: ", theWorld.name, startPosition, " parameters failed to find appropriate location.")
    end
end

function player:despawn()
    self.state = INACTIVE
end