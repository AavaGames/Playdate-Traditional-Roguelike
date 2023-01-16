class("frameProfiler").extends()

function frameProfiler:init()
    self:frameStart()
end

function frameProfiler:frameStart()
    self.timers = {}
    self.purposes = {}
    self.frameTime = chunkTimer("Frame")
end

function frameProfiler:startTimer(purpose)
    table.insert(self.purposes, purpose)
    self.timers[purpose] = chunkTimer(purpose)
end

function frameProfiler:endTimer(purpose)
    self.timers[purpose]:endTimer()
end

function frameProfiler:frameEnd()
    print("Frame Profile")
    for index, purpose in ipairs(self.purposes) do 
        if (self.timers[purpose] ~= nil) then
            self.timers[purpose]:print(false)
        else
            print(purpose .. " is nil")
        end
    end
    self.frameTime:print()
    print(1000 / (self.frameTime.endTime - self.frameTime.startTime) .. " fps")
end