class("chunkTimer").extends()

function chunkTimer:init(purpose)
    self.purpose = purpose or "Purpose"
    self.startTime = self:getMilliseconds()
    self.endTime = self.startTime
end

function chunkTimer:startTimer()
    self.startTime = self:getMilliseconds()
end

function chunkTimer:endTimer()
    self.endTime = self:getMilliseconds()
end

function chunkTimer:getMilliseconds()
    local time = playdate.getTime()
    return time.minute * 60000 + time.second * 1000 + time.millisecond
    -- bugs out if time frame starts on previous hour
end

function chunkTimer:print(endingTimer)
    if (endingTimer == nil or endingTimer == true) then
        self:endTimer()
    end
    print(self.purpose .. " took " .. self.endTime - self.startTime .. "m")
end