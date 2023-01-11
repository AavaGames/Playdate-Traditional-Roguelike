class("chunkTimer").extends()

function chunkTimer:init(purpose)
    self.purpose = purpose or "Purpose"
    self.startTime = playdate.getTime()
end

function chunkTimer:print()
    local endTime = playdate.getTime()
    print(self.purpose .. " took " .. endTime.second - self.startTime.second .. "s "
        .. endTime.millisecond - self.startTime.millisecond .. "m")
end