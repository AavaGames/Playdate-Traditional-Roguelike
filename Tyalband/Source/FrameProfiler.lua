class("FrameProfiler").extends()

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

function FrameProfiler:frameEnd()
    if (pDebug.profile == true) then
        pDebug:log("-- Frame Profile --")
        for index, purpose in ipairs(self.purposes) do 
            if (self.timers[purpose] ~= nil) then
                self.timers[purpose]:print(false)
            else
                pDebug:log(purpose .. " is nil")
            end
        end
        self.frameTime:print()
        pDebug:log(1000 / (self.frameTime.endTime - self.frameTime.startTime) .. " fps")
        pDebug:log("----")
    end
end