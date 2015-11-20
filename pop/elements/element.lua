local path = string.sub(..., 1, string.len(...) - string.len(".elements.element"))
local class = require(path .. ".lib.middleclass")
--TODO determine if these requires can break because of slashes / subdirectories

local element = class("pop.element")

function element:initialize(pop, parent)
    self.ax = 0 -- absolute locations
    self.ay = 0
    self.rx = 0 -- relative to parent locations
    self.ry = 0

    self.sizeControl = "fromInner" -- fromInner, fromOuter, specified
    self.outerWidth = 0
    self.outerHeight = 0
    self.innerWidth = 0
    self.innerHeight = 0

    self.skin = pop.skins[pop.currentSkin]
    self.visible = true

    self.parent = parent
    self.child = {}

    parent.child[self] = self -- add ourselves to the parent's children
end

--TODO completely redefine interface based on what we should expect users to do
-- REMEMBER the goal is minimal effort on their part
-- THEREFORE, we should reduce this interface, they should rely on skins for borderSize (and thus, differences in outer/inner sizes)
-- all calls should be based on sizing the outside, and update() should update inners (including children!) based on outers

function element:getSize()
    return self.outerWidth, self.outerHeight
end
function element:setSize(width, height)
    assert(width > 0, "width must be above 0")
    assert(height > 0, "height must be above 0")
    self.outerWidth = width
    self.outerHeight = height
    self.sizeControl = "specified"
end

function element:getOuterWidth()
    return self.outerWidth
end
function element:setOuterWidth(width)
    assert(width > 0, "width must be above 0")
    self.outerWidth = width
    self.sizeControl = "specified"
    --TODO needs to update() to update inner size based on borderSize ???
end

function element:getOuterHeight()
    return self.outerHeight()
end
function element:setOuterHeight(height)
    assert(height > 0, "height must be above 0")
    self.outerHeight = height
    self.sizeControl = "specified"
    --TODO needs to update() to update inner size based on borderSize ???
end

function element:getInnerWidth()
    return self.innerWidth
end
function element:setInnerWidth(width)
    assert(width > 0, "width must be above 0")
    self.innerWidth = width
    self.sizeControl = "specified"
    --TODO needs to update outerWidth ???
end

function element:getInnerHeight()
    return self.innerHeight
end
function element:setInnerHeight(height)
    assert(height > 0, "height must be above 0")
    self.innerHeight = height
    self.sizeControl = "specified"
    --TODO needs to update outerHeight ??
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
