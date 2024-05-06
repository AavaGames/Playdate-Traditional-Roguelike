---@class MenuManager
---@overload fun(onOpenFirstMenuCallback: function, onCloseAllMenusCallback:function): MenuManager
MenuManager = class("MenuManager").extends() or MenuManager

local gfx <const> = playdate.graphics

function MenuManager:init(onOpenFirstMenuCallback, onCloseAllMenusCallback)
    self.menus = {}
    self.currentMenu = nil
    self.showMenu = false

    -- menu ignores gfx.setScale
    self.screenWidth = screenManager.screenDimensions.x
    self.screenHeight = screenManager.screenDimensions.y

    self.backgroundColor = gfx.kColorBlack

    -- Can add callback to change Game State to disable play inputs
    self.OnOpenFirstMenu = onOpenFirstMenuCallback
    -- Can add callback to change Game State back to play
    self.OnCloseAllMenus = onCloseAllMenusCallback

    -- acts as an input consumer, 
    -- if A was used to close the menu and is used to open it, it wont open again in the same frame
    self.pauseAdding = false
end

function MenuManager:update()
    self.pauseAdding = false
    
    if (self.showMenu) then
        self.currentMenu:update()
    end
end

function MenuManager:draw()
    if (self.showMenu) then
        self.currentMenu:draw()
    end
end

function MenuManager:addMenu(menu)
    if (self.pauseAdding) then return end

    if (self.showMenu == false) then
        self.showMenu = true

        if (self.OnOpenFirstMenu) then
            self.OnOpenFirstMenu()
        end
    else
        self.menus[#self.menus]:setInactive()
    end
    table.insert(self.menus, menu)
    self.currentMenu = menu
    self.currentMenu:setActive()
end

function MenuManager:removeMenu()
    self.menus[#self.menus]:setInactive()
    table.remove(self.menus, #self.menus)
    if (#self.menus < 1) then
        self.currentMenu = nil
        self.showMenu = false
        self.pauseAdding = true

        if (self.OnCloseAllMenus) then
            self.OnCloseAllMenus()
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

function MenuManager:setBackgroundColor(color)
    self.backgroundColor = color
end