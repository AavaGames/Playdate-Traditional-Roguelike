class("chunkTimer").extends()

function chunkTimer:init(purpose)
    self.purpose = purpose or "Purpose"
    self.startTime = playdate.getCurrentTimeMilliseconds()
    self.endTime = self.startTime
end

function chunkTimer:startTimer()
    self.startTime = playdate.getCurrentTimeMilliseconds()
end

function chunkTimer:endTimer()
    self.endTime = playdate.getCurrentTimeMilliseconds()
end

function chunkTimer:getTime()
    self:endTimer()
    return self.endTime - self.startTime
end

function chunkTimer:print(endingTimer)
    if (endingTimer == nil or endingTimer == true) then
        self:endTimer()
    end
    print(self.purpose .. " took " .. self.endTime - self.startTime .. "ms")
end