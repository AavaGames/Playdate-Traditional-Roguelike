---@class InventoryMenu : Object
---@overload fun(menuManager: MenuManager, player: Player): InventoryMenu
InventoryMenu = class("InventoryMenu").extends() or InventoryMenu

function InventoryMenu:init(menuManager, player)
    self.menuManager = menuManager
	self.player = player
    self.menu = nil

end

function InventoryMenu:open()
	local items = { MenuItem("Equipment", "1", true, false, false, function ()
		-- opens equipment menu
	end) }
	for index, value in ipairs(self.player.inventory.items) do
		table.insert(items,
		MenuItem(value:getName(), nil, true, false, false, function ()
			-- opens item menu
			--ItemMenu(self.menuManager, value):open()
		end))
	end
	self.menu = Menu(self.menuManager, "Inventory (Non-functional)", screenManager.menuFont, items)
    self.menuManager:addMenu(self.menu)
end