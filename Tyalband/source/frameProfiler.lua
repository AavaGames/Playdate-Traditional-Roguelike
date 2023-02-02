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
    if (screenManager.profiler == true) then
        print("-- Frame Profile --")
        for index, purpose in ipairs(self.purposes) do 
            if (self.timers[purpose] ~= nil) then
                self.timers[purpose]:print(false)
            else
                print(purpose .. " is nil")
            end
        end
        self.frameTime:print()
        print(1000 / (self.frameTime.endTime - self.frameTime.startTime) .. " fps")
        print("----")
    end
end