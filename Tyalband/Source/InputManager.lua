---@class InputManager
---@overload fun(): InputManager
InputManager = class("InputManager").extends() or InputManager

function InputManager:init()
    self.active = true

    self.startFrameTime = playdate.getCurrentTimeMilliseconds()
    self.deltaTime = 0

    self.buttonCount = 6
    self.buttons = {
        playdate.kButtonA,
        playdate.kButtonB,
        playdate.kButtonUp,
        playdate.kButtonDown,
        playdate.kButtonRight,
        playdate.kButtonLeft
    }

    self.held = {}
    for index, button in ipairs(self.buttons) do
        self.held[button] = {
            duration = 0,
            currently = false,
            just = false,
            was = false
        }
    end

    self.crankWasDocked = false
    self.crankJustDocked, self.crankJustUndocked = false, false

    -- In Milliseconds
    self.holdBufferTime = 300
    self.longHoldBufferTime = 1000
end

function InputManager:setActive(active)
    self.active = active -- TODO finish active implementation
end

function InputManager:update()
    self.deltaTime = playdate.getCurrentTimeMilliseconds() - self.startFrameTime
    self.startFrameTime = playdate.getCurrentTimeMilliseconds()

    for i = 1, #self.buttons, 1 do
        local button = self.buttons[i]
        local held = self.held[button]
        held.was = held.currently

        if playdate.buttonIsPressed(button) then
            held.duration += self.deltaTime
            if (held.duration >= self.holdBufferTime) then
                if (held.currently == false) then
                    held.just = true
                else
                    held.just = false
                end
                held.currently = true
            end
        else
            held.duration = 0
            held.currently = false
            held.just = false
        end
    end

    self.crankJustDocked, self.crankJustUndocked = false, false

    if (self.crankWasDocked ~= playdate.isCrankDocked()) then
        self.crankJustDocked = playdate.isCrankDocked()
        self.crankJustUndocked = not playdate.isCrankDocked()

        self.crankWasDocked = playdate.isCrankDocked()
    end
end

function InputManager:lateUpdate()

end

function InputManager:isPressed(button)
    return playdate.buttonIsPressed(button)
end

function InputManager:justPressed(button)
    return playdate.buttonJustPressed(button)
end

function InputManager:justReleased(button)
    return self.held[button].was == false and playdate.buttonJustReleased(button)
end

function InputManager:held(button) 
    return self.held[button].currently
end

function InputManager:heldLong(button)
    return self.held[button].just == false and self.held[button].duration >= self.longHoldBufferTime
end

--#region Crank

function InputManager:isCrankDocked()
    return playdate.isCrankDocked()
end

function InputManager:justCrankDocked()
    return self.crankJustDocked
end

function InputManager:justCrankUndocked()
    return self.crankJustUndocked
end

function InputManager:getCrankTicks(ticksPerRevolution)
    return playdate.getCrankTicks(ticksPerRevolution)
end

--#endregion