local path = string.sub(..., 1, string.len(...) - string.len(".elements.box"))
local class = require(path .. ".lib.middleclass")
local element = require(path .. ".elements.element")

local box = class("pop.box", element)

function box:initialize(pop, parent)
    element.initialize(self, pop, parent)
    self.sizeControl = "specified"
    self.outerWidth = 300
    self.outerHeight = 250
    self.innerWidth = self.outerWidth - self.skin.style.borderSize
    self.innerHeight = self.outerHeight - self.skin.style.borderSize
end

function box:update()
    --
end

function box:draw()
    --TODO find a way for relative x/y to be passed here, because else, we won't have proper coords for drawing
end

return box
