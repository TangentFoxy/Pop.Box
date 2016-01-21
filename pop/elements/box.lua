local lg = love.graphics

local path = string.sub(..., 1, string.len(...) - string.len("/elements/box"))
local class = require(path .. "/lib/middleclass")
local element = require(path .. "/elements/element")

local box = class("pop.box", element)

function box:initialize(pop, parent, background)
    element.initialize(self, pop, parent)

    self.background = background or false
end

function box:draw() --NOTE these ifs are probably wrong
    if self.background then
        if type(self.background) == "table" then
            lg.setColor(self.background)
            lg.rectangle("fill", self.x, self.y, self.w, self.h)
        else
            lg.setColor(255, 255, 255, 255)
            local w, h = self.background:getDimensions()
            -- scale!
            w = self.w/w
            h = self.h/h
            lg.draw(self.background, self.x, self.y, 0, w, h)
        end
    end

    return self
end

function box:setBackground(background)
    self.background = background

    return self
end

function box:getBackground()
    return self.background
end

function box:setColor(r, g, b, a)
    self.background = {r, g, b, a}

    if not a then
        self.background[4] = 255
    end

    return self
end

function box:getColor()
    if type(self.background) == "table" then
        return self.background[1], self.background[1], self.background[3], self.background[4]
    else
        error("This box doesn't have a color.")
    end
end

return box
