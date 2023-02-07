class("ChunkTimer").extends()

function ChunkTimer:init(purpose)
    self.purpose = purpose or "Purpose"
    self.startTime = playdate.getCurrentTimeMilliseconds()
    self.endTime = self.startTime
end

function ChunkTimer:startTimer()
    self.startTime = playdate.getCurrentTimeMilliseconds()
end

function ChunkTimer:endTimer()
    self.endTime = playdate.getCurrentTimeMilliseconds()
end

function ChunkTimer:getTime()
    self:endTimer()
    return self.endTime - self.startTime
end

function ChunkTimer:print(endingTimer)
    if (endingTimer == nil or endingTimer == true) then
        self:endTimer()
    end
    pDebug:log(self.purpose .. " took " .. self.endTime - self.startTime .. "ms")
end