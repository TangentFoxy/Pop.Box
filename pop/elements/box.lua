local path = string.sub(..., 1, string.len(...) - string.len("/elements/box"))
local class = require(path .. "/lib/middleclass")
local element = require(path .. "/elements/element")

local box = class("pop.box", element) --TODO follow middleclass standards!?@@R/

function box:initialize(pop, parent, skin)
    element.initialize(self, pop, parent, skin)
end

return box
