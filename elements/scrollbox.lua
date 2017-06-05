local graphics
graphics = love.graphics
local element = require(tostring((...):sub(1, -10)) .. "/element")
local scrollbox
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      graphics.setColor(self.data.color)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      return self
    end,
    setBackground = function(self, r, g, b, a)
      if a == nil then
        a = 255
      end
      if "table" == type(r) then
        self.data.color = r
      else
        self.data.color = r, g, b, a
      end
      return self
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, data)
      if data == nil then
        data = { }
      end
      self.parent, self.data = parent, data
      _class_0.__parent.__init(self, self.parent, self.data)
      if self.data.type == "element" then
        self.data.type = "scrollbox"
      end
      self.data.color = {
        0,
        0,
        0,
        255
      }
    end,
    __base = _base_0,
    __name = "scrollbox",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  scrollbox = _class_0
  return _class_0
end
