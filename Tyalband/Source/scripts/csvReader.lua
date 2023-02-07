	-- CSV to 2D table --

function readCSV(path)
	local timer = ChunkTimer("reading " .. path)

	local file = playdate.file.open(path)
	assert(file, "Failed to retrieve CSV at " .. path)

	local fileTable = {}
	local i = 1
	while true do
		local line = file:readline()
		fileTable[i] = {}
		if line ~= nil then
			for str in string.gmatch(line, "([^,]+)") do
                table.insert(fileTable[i], str)
        	end
			pDebug:log(fileTable[i])
		else
			break
		end
		i += 1
	end

	timer:print()
    return fileTable
end