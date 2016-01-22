local lg = love.graphics

local path = string.sub(..., 1, string.len(...) - string.len("/elements/text"))
local class = require(path .. "/lib/middleclass")
local element = require(path .. "/elements/element")

local text = class("pop.text", element)

function text:initialize(pop, parent, text, color)
    element.initialize(self, pop, parent)

    self.font = lg.newFont()
    self:setText(text or "")
    self.color = color or {255, 255, 255, 255}
end

function text:draw()
    lg.setColor(self.color)
    lg.setFont(self.font)
    lg.print(self.text, self.x, self.y)

    return self
end

function text:setSize()
    local w = self.font:getWidth(self.text)
    local h = self.font:getHeight()

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

function text:setText(text)
    self.text = text

    self:setSize()

    return self
end

function text:getText()
    return self.text
end

function text:setFont(font)
    self.font = font
    self:setSize()

    return self
end

function text:getFont()
    return self.font
end

function text:setColor(r, g, b, a)
    self.color = {r, g, b, a}

    if not a then
        self.color[4] = 255
    end

    return self
end

function text:getColor()
    return self.color[1], self.color[1], self.color[3], self.color[4]
end

return text
