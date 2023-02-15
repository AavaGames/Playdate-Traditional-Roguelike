class("ItemMenu").extends()

function ItemMenu:init(menuManager, item)
    self.menuManager = menuManager
	self.item = item
    self.menu = nil
	
	-- TODO create menu for item: Apply, Drop, Equip (Left, Right), Throw, etc.
end

function ItemMenu:open()
	self.menuManager:addMenu(self.menu)
end