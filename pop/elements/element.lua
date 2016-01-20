local path = string.sub(..., 1, string.len(...) - string.len("/elements/element"))
local class = require(path .. "/lib/middleclass")

local element = class("pop.element") --TODO follow middleclass standards!?@@R/

function element:initialize(pop, parent, skin)
    self.parent = parent
    self.child = {}

    self.x = parent.x or 0
    self.y = parent.y or 0
    self.w = 10
    self.h = 10

    self.skin = pop.skins[skin] or pop.skins[pop.currentSkin]
    self.alignment = "top-left"
end

function element:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

function element:setPosition(x, y)
    if self.alignment == "top-left" then
        self.x = x
        self.y = y
    elseif self.alignment == "top-center" then
        self.x = x - self.w/2
        self.y = y
    elseif self.alignment == "top-right" then
        self.x = x - self.w
        self.y = y
    elseif self.alignment == "left-center" then
        self.x = x
        self.y = y - self.h/2
    elseif self.alignment == "center" then
        self.x = x - self.w/2
        self.y = y - self.h/2
    elseif self.alignment == "right-center" then
        self.x = x - self.w
        self.y = y - self.h/2
    elseif self.alignment == "bottom-left" then
        self.x = x
        self.y = y - self.h
    elseif self.alignment == "bottom-center" then
        self.x = x - self.w/2
        self.y = y
    elseif self.alignment == "bottom-right" then
        self.x = x - self.w
        self.y = y - self.h
    end
end

function element:getPosition()
    if self.alignment == "top-left" then
        return self.x, self.y
    elseif self.alignment == "top-center" then
        return self.x + self.w/2, self.y
    elseif self.alignment == "top-right" then
        return self.x + self.w, self.y
    elseif self.alignment == "left-center" then
        return self.x, self.y + self.h/2
    elseif self.alignment == "center" then
        return self.x + self.w/2, self.y + self.h/2
    elseif self.alignment == "right-center" then
        return self.x + self.w, self.y + self.h/2
    elseif self.alignment == "bottom-left" then
        return self.x, self.y + self.h
    elseif self.alignment == "bottom-center" then
        return self.x + self.w/2, self.y
    elseif self.alignment == "bottom-right" then
        return self.x + self.w, self.y + self.h
    end
end

function element:setSize(w, h)
    if self.alignment == "top-left" then
        self.w = w
        self.h = h
    elseif self.alignment == "top-center" then
        -- x minus half difference to expand horizontally
        self.x = self.x - (w - self.w)/2
        self.w = w
        self.h = h
    elseif self.alignment == "top-right" then
        -- x minus difference to expand left
        self.x = self.x - (w - self.w)
        self.w = w
        self.h = h
    elseif self.alignment == "left-center" then
        self.y = self.y - (h - self.h)/2
        self.w = w
        self.h = h
    elseif self.alignment == "center" then
        self.x = self.x - (w - self.w)/2
        self.y = self.y - (h - self.h)/2
        self.w = w
        self.h = h
    elseif self.alignment == "right-center" then
        self.x = self.x - (w - self.w)
        self.y = self.y - (h - self.h)/2
        self.w = w
        self.h = h
    elseif self.alignment == "bottom-left" then
        self.y = self.y - (h - self.h)
        self.w = w
        self.h = h
    elseif self.alignment == "bottom-center" then
        self.x = self.x - (w - self.w)/2
        self.y = self.y - (h - self.h)
        self.w = w
        self.h = h
    elseif self.alignment == "bottom-right" then
        self.x = self.x - (w - self.w)
        self.y = self.y - (h - self.h)
        self.w = w
        self.h = h
    end
end

function element:getSize()
    return self.w, self.h
end

function element:align(alignment)
    self.alignment = alignment

    if self.alignment == "top-left" then
        self.x = self.parent.x
        self.y = self.parent.y
    elseif self.alignment == "top-center" then
        -- parent's x plus half of difference in width to center
        self.x = self.parent.x + (self.parent.w - self.w)/2
        self.y = self.parent.y
    elseif self.alignment == "top-right" then
        -- parent's x plus difference in width to align right
        self.x = self.parent.x + (self.parent.w - self.w)
        self.y = self.parent.y
    elseif self.alignment == "left-center" then
        self.x = self.parent.x
        self.y = self.parent.y + (self.parent.h - self.h)/2
    elseif self.alignment == "center" then
        self.x = self.parent.x + (self.parent.w - self.w)/2
        self.y = self.parent.y + (self.parent.h - self.h)/2
    elseif self.alignment == "right-center" then
        self.x = self.parent.x + (self.parent.w - self.w)
        self.y = self.parent.y + (self.parent.h - self.h)/2
    elseif self.alignment == "bottom-left" then
        self.x = self.parent.x
        self.y = self.parent.y + (self.parent.h - self.h)
    elseif self.alignment == "bottom-center" then
        self.x = self.parent.x + (self.parent.w - self.w)/2
        self.y = self.parent.y + (self.parent.h - self.h)
    elseif self.alignment == "bottom-right" then
        self.x = self.parent.x + (self.parent.w - self.w)
        self.y = self.parent.y + (self.parent.h - self.h)
    end
end

function element:alignTo(element, alignment)
    local realParent = self.parent
    self.parent = element

    self:align(alignment)

    self.parent = realParent
end

function element:setAlignment(alignment)
    self.alignment = alignment
end

function element:setSkin(skin)
    if type(skin) == "string" then
        self.skin = pop.skins[skin]
    else
        self.skin = skin
    end
end

return element
