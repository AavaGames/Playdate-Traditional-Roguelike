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
        self.gameManager:setState(self.gameManager.GameStates.Menu)
    else
        self.menus[#self.menus]:setInactive()
    end
    table.insert(self.menus, menu)
    self.currentMenu = menu
    self.currentMenu:setActive()
end

function MenuManager:removeMenu()
    self.menus[#self.menus]:setInactive()
    pDebug:log(self.menus[#self.menus].name .. " menu is removed")
    table.remove(self.menus, #self.menus)
    if (#self.menus < 1) then
        self.currentMenu = nil
        self.showMenu = false
        if (self.gameManager:isState(self.gameManager.GameStates.Menu)) then
            self.gameManager:setState(self.gameManager.GameStates.Level)
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