import "~global"

local gfx <const> = playdate.graphics

local function initializeGame()
	playdate.display.setRefreshRate(targetFPS)
	math.randomseed(playdate.getSecondsSinceEpoch())
	gfx.setBackgroundColor(gfx.kColorWhite)

	gameManager = gameManager()
	screenManager = screenManager()

	--text = worldFont:getGlyph("O")
	--blur = text:fadedImage(0.5, playdate.graphics.image.kDitherTypeBayer2x2)
end

local function updateGame()
	gameManager:update()
	gameManager:lateUpdate()
end

local function drawGame()
	if (gameManager.worldManager.currentWorld.redrawWorld) then
		gfx.clear()
		gfx.sprite.update()

		gameManager:draw()

		--text:draw(40, 40)
		--text:draw(70, 40)
		--blur:draw(60,60)
	end
end

initializeGame()

function playdate.update()
	playdate.timer.updateTimers()
	updateGame()
	drawGame()

	if fps then
		playdate.drawFPS(0,0)
	end
end