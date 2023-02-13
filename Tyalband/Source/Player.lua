local gfx <const> = playdate.graphics

class("Player").extends(Actor)

function Player:init(menuManager)
    Player.super.init(self)
    self.glyph = "@"
    self.name = "You"
    self.description = "A striking individual, who seems to be quite powerful"

    self.moveDir = { x = 0, y = 0 }
    self.state = self.states.Inactive

    self.visionRange = -1 -- Infinity

    self.inventory = self:addComponent(Inventory())
    self.equipment = self:addComponent(Equipment())
    self.equipment.onEquipmentChange = function() self:updateEquipmentMenuImage() end

    self:addComponent(LightEmitter())

    local lantern = Lantern()
    lantern:equip(self)
    --self:addComponent(LightSource(2, 4)):addToEmitter()

    for i = 1, 28, 1 do
        Item():pickup(self)
    end

    self.inventoryMenu = InventoryMenu(menuManager, self)
	self.invPDMenu, error = playdate.getSystemMenu():addMenuItem("Inventory", function()
        self.inventoryMenu:open()
    end)
end

function Player:update()
    if (self.state == self.states.Active) then
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
            self.level:round(moved)
        end
    end
end

function Player:round() end

function Player:interact(actor)
    if (actor ~= nil) then
        gameManager.logManager:addToRound("The " .. actor.name .. " bumps into you.")
        actor:interact(self)
    end
end

function Player:spawn(theLevel, startPosition)
    self.position = Vector2.zero()
    self.updated = false
    self.state = self.states.Active

    self.level = theLevel
    self.tile = nil
    if (theLevel ~= nil and startPosition ~= nil) then
        self:moveTo(Vector2.new(startPosition.x, startPosition.y)) -- TODO: can spawn on top of another actor overwriting their pos (SpawnAt)
    else
        pDebug:log("SPAWNING ERROR: ", theLevel.name, startPosition, " parameters failed to find appropriate location.")
    end
end

function Player:despawn()
    self.state = self.states.Inactive
end

function Player:updateEquipmentMenuImage()
    local screenManager = screenManager
    local image = gfx.image.new(screenManager.screenDimensions.x, screenManager.screenDimensions.y, gfx.kColorBlack)
    gfx.lockFocus(image)
    gfx.setFont(screenManager.logFont_8px.font)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    gfx.drawTextAligned("Equipment", screenManager.screenDimensions.x / 4, 1, kTextAlignment.center)
    local text = ""
    -- TODO make a big if to properly show this
    for key, value in pairs(self.equipment.slots) do
        if (value ~= "") then
            text = text .. key .. ": " .. value.name .. "\n"
        else
            text = text .. key .. ":\n"
        end
    end
    gfx.drawTextInRect(text, 0, 20, 200, 200)
    gfx.unlockFocus()
    playdate.setMenuImage(image)
end