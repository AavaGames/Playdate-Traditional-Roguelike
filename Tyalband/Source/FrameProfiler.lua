local gfx <const> = playdate.graphics

---@class FrameProfiler : Object
---@overload fun(): FrameProfiler
FrameProfiler = class("FrameProfiler").extends() or FrameProfiler

function FrameProfiler:init()
    self:frameStart()
end

function FrameProfiler:frameStart()
    self.timers = {}
    self.purposes = {}
    self.frameTime = ChunkTimer("Frame")
end

function FrameProfiler:startTimer(purpose)
    table.insert(self.purposes, purpose)
    self.timers[purpose] = ChunkTimer(purpose)
end

function FrameProfiler:endTimer(purpose)
    self.timers[purpose]:endTimer()
end

---@param shouldPrint boolean Should a print be made?
function FrameProfiler:endFrame(shouldPrint)
    if (shouldPrint and pDebug.profile == true) then
        print("-- Frame Profile --")
        for index, purpose in ipairs(self.purposes) do 
            if (self.timers[purpose] ~= nil) then
                self.timers[purpose]:print(false)
            else
                print(purpose .. " is nil")
            end
        end
        self.frameTime:print()
        local stats = playdate.getStats()
        if stats ~= nil then printTable(stats) end
        print(1000 / (self.frameTime.endTime - self.frameTime.startTime) .. " fps")
        print("----")
    end
    if (shouldPrint and pDebug.frameTime == true) then
        gfx.setColor(gfx.kColorWhite)
        local font = screenManager.logFont_6px
        local frameTime = 1000 / (self.frameTime.endTime - self.frameTime.startTime)
        frameTime = math.floor(frameTime * 10) / 10
        local width, height = gfx.getTextSize(frameTime)
        gfx.fillRect(0, 0, width, height)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.setFont(font.font)
        gfx.drawText(frameTime, 0, 0)
    end
end