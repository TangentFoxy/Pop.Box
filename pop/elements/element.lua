local path = string.sub(..., 1, string.len(...) - string.len("/elements/element"))
local class = require(path .. "/lib/middleclass")

local element = class("pop.element")

function element:initialize(pop, parent)
    self.parent = parent
    self.child = {}

    self.x = parent.x or 0
    self.y = parent.y or 0
    self.w = 10
    self.h = 10

    self.horizontal = "left"
    self.vertical = "top"
end

function element:move(x, y)
    self.x = self.x + x
    self.y = self.y + y

    for i=1,#element.child do
        if not element.child[i].excludeMovement then
            element.child[i]:move(x - oldX, y - oldY)
        end
    end

    return self
end

function element:setPosition(x, y)
    local oldX = self.x
    local oldY = self.y

    if self.horizontal == "left" then
        self.x = x
    elseif self.horizontal == "center" then
        self.x = x - self.w/2
    elseif self.horizontal == "right" then
        self.x = x - self.w
    end

    if self.vertical == "top" then
        self.y = y
    elseif self.vertical == "center" then
        self.y = y - self.h/2
    elseif self.vertical == "bottom" then
        self.y = y - self.h
    end

    for i=1,#element.child do
        if not element.child[i].excludeMovement then
            element.child[i]:move(x - oldX, y - oldY)
        end
    end

    return self
end

function element:getPosition()
    local resultX = self.x
    local resultY = self.y

    if self.horizontal == "center" then
        resultX = resultX + self.w/2
    elseif self.horizontal == "right" then
        resultX = resultX + self.w
    end

    if self.vertical == "center" then
        resultY = resultY + self.h/2
    elseif self.vertical == "bottom" then
        resultY = resultY + self.h
    end

    return resultX, resultY
end

function element:setSize(w, h)
    if self.horizontal == "center" then
        self.x = self.x - (w - self.w)/2
    elseif self.horizontal == "right" then
        self.x = self.x - (w - self.w)
    end

    if self.vertical == "center" then
        self.y = self.y - (h - self.h)/2
    elseif self.vertical == "bottom" then
        self.y = self.y - (h - self.h)
    end

    self.w = w
    self.h = h

    return self
end

function element:getSize()
    return self.w, self.h
end

function element:adjustSize(x, y)
    local X, Y = self:getSize()
    self:setSize(X + x, Y + y)

    return self
end

function element:align(horizontal, vertical)
    self:setAlignment(horizontal, vertical)

    self.x = self.parent.x
    self.y = self.parent.y

    if self.horizontal == "center" then
        self.x = self.x + (self.parent.w - self.w)/2
    elseif self.horizontal == "right" then
        self.x = self.x + (self.parent.w - self.w)
    end

    if self.vertical == "center" then
        self.y = self.y + (self.parent.h - self.h)/2
    elseif self.vertical == "bottom" then
        self.y = self.y + (self.parent.h - self.h)
    end

    return self
end

function element:alignTo(element, horizontal, vertical)
    local realParent = self.parent
    self.parent = element

    self:align(alignment)

    self.parent = realParent

    return self
end

function element:setAlignment(horizontal, vertical)
    if horizontal then
        self.horizontal = horizontal
    end
    if vertical then
        self.vertical = vertical
    end

    return self
end

return element
