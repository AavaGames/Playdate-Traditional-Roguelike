class("player").extends(actor)

function player:init(theWorld, startPosition)
    player.super.init(self, theWorld, startPosition)
    self.char = "O"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful!"

    self.moveDir = { x = 0, y = 0 }

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
        if playdate.buttonJustPressed(playdate.kButtonRight) then
            self.moveDir.x += 1
        end
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.moveDir.x -= 1
        end
        if playdate.buttonJustPressed(playdate.kButtonUp) then
            self.moveDir.y -= 1
        end
        if playdate.buttonJustPressed(playdate.kButtonDown) then
            self.moveDir.y += 1
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

function player:spawn(theWorld, vectorPosition)
    self.position = Vector2.zero()
    self.updated = false
    self.state = ACTIVE

    self.world = theWorld
    self.tile = nil
    if (theWorld ~= nil and vectorPosition ~= nil) then
        self:move(vectorPosition) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        print("SPAWNING ERROR: ", theWorld.name, vectorPosition, " parameters failed to find appropriate location.")
    end
end

function player:despawn()
    self.state = INACTIVE
end