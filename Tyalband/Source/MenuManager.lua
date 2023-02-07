class("MenuManager").extends()

function MenuManager:init(gameManager)
    self.gameManager = gameManager
    screenManager.menuManager = self
    self.menus = {}
    self.currentMenu = nil
    self.showMenu = false
end

function MenuManager:update()
    self.currentMenu:update()
end

function MenuManager:draw()
    self.currentMenu:draw()
end

function MenuManager:addMenu(menu)
    if (self.showMenu == false) then
        self.showMenu = true
        self.gameManager:setState(self.gameManager.gameStates.menu)
    end
    table.insert(self.menus, menu)
    self.currentMenu = menu
    self.currentMenu:setActive()
end

function MenuManager:removeMenu()
    pDebug:log(self.menus[#self.menus].name .. " menu is removed")
    self.menus[#self.menus]:setInactive()
    table.remove(self.menus, #self.menus)
    if (#self.menus < 1) then
        self.currentMenu = nil
        self.showMenu = false
        if (self.gameManager:isState(self.gameManager.gameStates.menu)) then
            self.gameManager:setState(self.gameManager.gameStates.level)
        end
    else
        self.currentMenu = self.menus[#self.menus]
        self.currentMenu:setActive()
    end
end

function MenuManager:removeAllMenu()
    for i = 1, #self.menus, 1 do
        self:removeMenu()
    end
end