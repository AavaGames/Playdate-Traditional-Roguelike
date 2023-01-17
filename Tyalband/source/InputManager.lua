class("InputManager").extends()

function InputManager:init()
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

    -- In Milliseconds
    self.holdBufferTime = 300
    self.longHoldBufferTime = 1000
end

function InputManager:update()
    self.deltaTime = playdate.getCurrentTimeMilliseconds() - self.startFrameTime
    self.startFrameTime = playdate.getCurrentTimeMilliseconds()

    for index, button in ipairs(self.buttons) do

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
end

function InputManager:IsPressed(button)
    return playdate.buttonIsPressed(button)
end

function InputManager:JustPressed(button)
    return playdate.buttonJustPressed(button)
end

function InputManager:JustReleased(button)
    return self.held[button].was == false and playdate.buttonJustReleased(button)
end

function InputManager:Held(button) 
    return self.held[button].currently
end

function InputManager:HeldLong(button)
    return self.held[button].just == false and self.held[button].duration >= self.longHoldBufferTime
end