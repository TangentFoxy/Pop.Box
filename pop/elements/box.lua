local lg = love.graphics

local path = string.sub(..., 1, string.len(...) - string.len("/elements/box"))
local class = require(path .. "/lib/middleclass")
local element = require(path .. "/elements/element")

local box = class("pop.box", element)

function box:initialize(pop, parent, skin)
    element.initialize(self, pop, parent, skin)
end

function box:draw() --TODO these ifs are probably wrong
    print("box drawn!")

    if self.skin.background then
        if type(self.skin.background) == "table" then
            lg.setColor(self.skin.background)
            print(self.skin.background[4], self.x, self.y, self.w, self.h)
            lg.rectangle("fill", self.x, self.y, self.w, self.h)
            print("rect")
        else
            lg.setColor(255, 255, 255, 255)
            local w, h = self.skin.background:getDimensions()
            -- scale!
            w = self.w/w
            h = self.h/h
            lg.draw(self.skin.background, self.x, self.y, 0, w, h)
        end
    end

    if self.skin.foreground then
        if type(self.skin.foreground) == "table" then
            lg.setColor(self.skin.foreground)
            lg.rectangle("fill", self.x, self.y, self.w, self.h)
        else
            lg.setColor(255, 255, 255, 255)
            local w, h = self.skin.foreground:getDimensions()
            -- scale!
            w = self.w/w
            h = self.h/h
            lg.draw(self.skin.foreground, self.x, self.y, 0, w, h)
        end
    end

    return self
end

return box
