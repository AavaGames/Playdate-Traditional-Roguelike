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

    -- update health with class HP
    self.health:setMaxHP(10)
    -- insert Stats
    self.race = nil -- Race component
        -- adds innate
    self.class = nil -- Class component
        -- adds spellbook / mana

    self.inventory = self:addComponent(Inventory())
    self.equipment = self:addComponent(Equipment())
    self.equipment.onEquipmentChange = function() self:updateEquipmentMenuImage() end

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

    --self.moveSpeed = 1
end

function Player:update()
    if (self.state == self.States.Active) then

        self.currentTarget = nil  -- show only when hitting? or only stop after not seen or mon death

        self.moveDir = Vector2.zero()
        if inputManager:justPressed(playdate.kButtonB) then
            self:actionEnd(self.TurnTicks) -- wait 1 turn, change to movespeed?
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
                self:actionEnd(self:getTicks(self.moveSpeed))
            end
        end

    end
end

function Player:round(ticks) end -- remove super round

function Player:actionEnd(ticks)
    self.ticksTillAction = ticks -- used to give monsters energy

    gameManager.gameStats.actionCounter += 1
    self.level:round()
end

function Player:interact()

    if (self.currentTarget:isa(Monster)) then
        --self:attack()
        gameManager.logManager:addToRound(self.name .. " bumps into " .. self.currentTarget.name .. ".")

        self.currentTarget.health:damage(1)

        self:actionEnd(self.TurnTicks)

    elseif (self.currentTarget:isa(Feature)) then
        self.currentTarget:logDescription()

    elseif (self.currentTarget:isa(NPC)) then
        -- self.currentTarget:talk()
    end

end

function Player:attack()
    Player.super.attack(self)
    
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

function Player:death()
    gameManager.logManager:addToRound("%s is cuddled to death.")
end