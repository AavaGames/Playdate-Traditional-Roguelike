class("MenuManager").extends()

function MenuManager:init(gameManager)
    self.gameManager = gameManager
    self.menus = {}
    self.currentMenu = nil
    self.showMenu = false
end

function MenuManager:update()
    self.menus[#self.menus]:update()
end

function MenuManager:draw()
    self.menus[#self.menus]:draw()
end

function MenuManager:addMenu(menu)
    if (self.showMenu == false) then
        self.showMenu = true
        self.currentMenu = menu
        self.gameManager:setState(self.gameManager.gameStates.menu)
    end
    table.insert(self.menus, menu)
    menu:setActive()
end

function MenuManager:removeMenu()
    table.remove(self.menus, #self.menus)
    print("remove menu")
    if (#self.menus < 1) then
        self.currentMenu = nil
        self.showMenu = false
        self.gameManager:setState(self.gameManager.gameStates.level)
    else
        self.menus[#self.menus]:setActive()
    end
end

