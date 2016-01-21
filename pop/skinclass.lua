--TODO make skins inherit this, and allow duplication and modification of skins on the fly
local path = string.sub(..., 1, string.len(...) - string.len("/skinclass"))
local class = require(path .. "/lib/middleclass")

local skinclass = class("pop.skinclass")

function skinclass:initialize()
    --
end

return skinclass
