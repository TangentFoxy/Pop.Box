local path = string.sub(..., 1, string.len(...) - string.len(".elements.element"))
local class = require(path .. ".lib.middleclass")

local element = class("pop.element") --NOTE are periods allowed in middleclass class names?

--TODO setting widths and heights need to call update()
--TODO setters and getters for just width/height, aliases for outerWidth/outerHeight

function element:initialize(pop, parent)
    self.x = 0
    self.y = 0
    self.alignPoint = 1 -- 1 to 9, how aligned relative to x/y, see docs

    self.sizeControl = "fromInner" -- fromInner, fromOuter, specified
    self.outerWidth = 0
    self.outerHeight = 0
    self.innerWidth = 0
    self.innerHeight = 0

    self.style = pop.style
    self.visible = true

    self.parent = parent
    self.child = {}

    parent.child[self] = self -- add ourselves to the parent's children
end

function element:getAlignPoint()
    return self.alignPoint
end
function element:setAlignPoint(point)
    self.alignPoint = point
end

function element:getOuterWidth()
    return self.outerWidth
end
function element:setOuterWidth(width)
    assert(width > 0, "width must be above 0")
    self.outerWidth = width
end

function element:getOuterHeight()
    return self.outerHeight()
end
function element:setOuterHeight(height)
    assert(height > 0, "height must be above 0")
    self.outerHeight = height
end

function element:getInnerWidth()
    return self.innerWidth
end
function element:setInnerWidth(width)
    assert(width > 0, "width must be above 0")
    self.innerWidth = width
end

function element:getInnerHeight()
    return self.innerHeight
end
function element:setInnerHeight(height)
    assert(height > 0, "height must be above 0")
    self.innerHeight = height
end

--[[ TODO determine how to write these better (consistency motherfucker)
function element:getStyle()
    return self.style.name
end
function element:setStyle(style)
    self.style = style
end
]]

function element:getVisible()
    return self.visible
end
function element:setVisible(bool)
    self.visible = bool
end

function element:getParent()
    return self.parent
end
function element:setParent(parent)
    self.parent.child[self] = nil
    self.parent = parent
    self.parent.child[self] = self
end

--TODO figure out how getting and setting children might work? or no??

function element:update()
    --TODO a proper error message
    print("update() not deifnenfei")
end

function element:draw()
    --TODO figure out how to get class name
    print("Attempting to use element, or did not overwrite element's :draw() method.")
end

return element
