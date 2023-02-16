function saveGame()
	if (gameManager.initialized) then
		print("SAVE GAME")
		local saveTable = { gameManager.gameStats }
		printTable(saveTable)
		playdate.datastore.write(saveTable, "save", true)
	end
end

function loadGame()
	local saveTable = playdate.datastore.read("save")
	if (saveTable ~= nil) then
		print("LOAD GAME")
		printTable(saveTable)
		gameManager.gameStats = saveTable[1]
	end
end