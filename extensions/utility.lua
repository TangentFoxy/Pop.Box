local graphics
graphics = love.graphics
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/extensions/streamlined_get_set"))
local element = require(tostring(path) .. "/elements/element")
element.__base.fill = function(self)
  self.data.x = self.parent.data.x + self.data.padding
  self.data.y = self.parent.data.y + self.data.padding
  self.data.w = self.parent.data.w - self.data.padding * 2
  self.data.h = self.parent.data.h - self.data.padding * 2
end
