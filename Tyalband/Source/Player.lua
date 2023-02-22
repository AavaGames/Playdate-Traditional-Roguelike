local gfx <const> = playdate.graphics

class("Player").extends(Actor)

function Player:init(menuManager)
    Player.super.init(self)
    self.inventoryMenu = InventoryMenu(menuManager, self)
	self.invPDMenu, error = playdate.getSystemMenu():addMenuItem("Inventory", function()
        self.inventoryMenu:open()
    end)

    self.glyph = "@"
    self.name = "Vin"
    self.description = "grew up as an urchin in the great city. They had to steal to survive."

    self.moveDir = { x = 0, y = 0 }
    self.state = self.States.Inactive

    self.visionRange = -1 -- Infinity
    self.scentRange = 6 -- range at which normal smell will detect
    self.isMoving = false -- motion flag
    self.soundRange = 0 -- 

    -- update with class HP
    self.inventory = self:addComponent(Health(10))
    -- insert Stats
    self.race = nil -- Race component
        -- adds innate
    self.class = nil -- Class component
        -- adds spellbook / mana

    self.inventory = self:addComponent(Inventory())
    self.equipment = self:addComponent(Equipment())
    self.equipment.onEquipmentChange = function() self:updateEquipmentMenuImage() end

    self.currentTarget = nil

    self:addComponent(LightEmitter())
    -- add inventory from race / class

    local lantern = Lantern()
    lantern:equip(self)
    --self:addComponent(LightSource(2, 4)):addToEmitter()
    for i = 1, 12, 1 do
        Item():pickup(self)
    end
    for i = 1, 12, 1 do
        Equipable():pickup(self)
    end
end

function Player:update()
    if (self.state == self.States.Active) then
        self.currentTarget = nil  -- show only when hitting? or only stop after not seen or mon death

        self.moveDir = Vector2.zero()
        local actionTaken, moved = false, false

        if inputManager:justPressed(playdate.kButtonB) then
            actionTaken = true -- wait
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
            gameManager.gameStats.actionCounter += 1
            self.level:round(moved)
        end
    end
end

function Player:round() end

function Player:interact(actor) -- they interact with player
    if (actor ~= nil) then
        self.currentTarget = actor
        gameManager.logManager:addToRound("The " .. actor.name .. " bumps into " .. self.name .. ".")
        actor:interact(self)
    end
end

function Player:spawn(theLevel, startPosition)
    self.position = Vector2.zero()
    self.updated = false
    self.state = self.States.Active

    self.level = theLevel
    self.tile = nil
    if (theLevel ~= nil and startPosition ~= nil) then
        self:moveTo(Vector2.new(startPosition.x, startPosition.y)) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        pDebug:log("SPAWNING ERROR: ", theLevel.name, startPosition, " parameters failed to find appropriate location.")
    end
end

function Player:despawn()
    self.state = self.States.Inactive
end

function Player:updateEquipmentMenuImage()
    local screenManager = screenManager
    local image = gfx.image.new(screenManager.screenDimensions.x, screenManager.screenDimensions.y, gfx.kColorBlack)
    local font = screenManager.logFont_6px
    gfx.lockFocus(image)
    gfx.setFont(font.font)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    -- Character Name
    gfx.drawTextAligned(self.name, screenManager.screenDimensions.x / 4, 1, kTextAlignment.center)
    local text = ""
    local emptyText <const> = "" --"Ring of Awareness {+3}"
    for index, value in ipairs(self.equipment.slots) do
        if (value ~= false) then
            text = text .. enum.getName(eEquipmentSlots, index) .. ": " .. value:getName() .. "\n"
        else
            text = text .. enum.getName(eEquipmentSlots, index) .. ": " .. emptyText .. "\n"
        end
        if (index == eEquipmentSlots.Light or index == eEquipmentSlots.OffHand or index == eEquipmentSlots.Feet) then
            text = text .. "\n"
        end
    end
    text = text .. "\n" .. "Scent - " .. self.scentRange .. " / Sound - " .. self.soundRange

    local offset = font.size.height + 1
    gfx.drawTextInRect(text, 0, offset, 200, 240 - offset)
    gfx.unlockFocus()
    playdate.setMenuImage(image)
end