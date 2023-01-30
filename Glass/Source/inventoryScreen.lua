local logGrid = ui.gridview.new(32, 32)
logGrid:setNumberOfRows(4)
logGrid:setNumberOfColumns(4)
logGrid:setContentInset(0, 0, 0, 0)

function logGrid:drawCell(section, row, column, selected, x, y, width, height)

    gfx.drawCircleAtPoint(x,y,width,height)
    -- gfx.setImageDrawMode(playdate.graphics.kDrawModeNXOR)

    local text = "text"

    -- print(text)

    --gfx.drawTextInRect(text, x, y, width, height)

end

        --logGrid:drawInRect(self.position.x, self.position.y, self.size.x, self.size.y)
