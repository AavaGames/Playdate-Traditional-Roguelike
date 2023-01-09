class("player").extends(actor)

function player:init(theWorld, x, y)
    player.super.init(self, theWorld, x, y)
    self.char = "O"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful!"

    self.moveDir = { x = 0, y = 0 }
    self.moveSpeed = 5
    self.canMove = true;

    self.kb = false

    -- local menu = playdate.getSystemMenu()
    -- local inventoryMenu, error = menu:addMenuItem("Inventory", function()
    --     print("inventory opened")
    --     self.state = INACTIVE
    --     self.kb = true
    --     playdate.keyboard.show()
    -- end)
    --playdate.keyboard.textChangedCallback = function() self:inventoryUse() end
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
        self.moveDir = { x = 0, y = 0 }
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            self.moveDir.x += 1
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            self.moveDir.x -= 1
        end
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            self.moveDir.y -= 1
        end
        if playdate.buttonIsPressed(playdate.kButtonDown) then
            self.moveDir.y += 1
        end

        if (self.canMove) then
            if (self.moveDir.x ~= 0 or self.moveDir.y ~= 0) then
                self:move(self.moveDir.x, self.moveDir.y)
                self.canMove = false

                playdate.timer.performAfterDelay( 1000 / self.moveSpeed, function() self.canMove = true end)
            end
        end
    end
end

function player:inventoryUse()
    -- parse inventory
    print("picked: " .. playdate.keyboard.text)

    playdate.keyboard.hide()
end

function player:spawn(theWorld, x, y)
    self.x = 0
    self.y = 0
    self.updated = false
    self.state = ACTIVE

    print("SPAWNING ERROR: ", theWorld.name, x, y, " parameters failed to find appropriate location.")

    self.world = theWorld
    self.tile = nil
    if (theWorld ~= nil and x ~= nil and y ~= nil) then
        self:move(x, y) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        print("SPAWNING ERROR: ", theWorld.name, x, y, " parameters failed to find appropriate location.")
    end
end

function player:despawn()
    self.state = INACTIVE
end