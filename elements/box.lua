local graphics
graphics = love.graphics
local element = require(tostring((...):sub(1, -4)) .. "/element")
local box
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      if "table" == type(self.data.background) then
        graphics.setColor(self.data.background)
        graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      else
        local w, h = self.data.background:getDimensions()
        w = self.data.w / w
        h = self.data.h / h
        graphics.setColor(255, 255, 255, 255)
        graphics.draw(self.data.background, self.data.x, self.data.y, 0, w, h)
      end
      return self
    end,
    setBackground = function(self, background)
      if background then
        self.data.background = background
      else
        error("Background must be a table representing a color, or a drawable object.")
      end
      return self
    end,
    getBackground = function(self)
      return self.data.background
    end,
    setColor = function(self, r, g, b, a)
      if a == nil then
        a = 255
      end
      if "table" == type(r) then
        self.data.background = r
      else
        self.data.background = {
          r,
          g,
          b,
          a
        }
      end
      return self
    end,
    getColor = function(self)
      if "table" == type(self.data.background) then
        return unpack(self.data.background)
      else
        return 255, 255, 255, 255
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, data, background)
      if data == nil then
        data = { }
      end
      if background == nil then
        background = {
          255,
          255,
          255,
          255
        }
      end
      self.parent, self.data = parent, data
      if #self.data == 4 then
        background = self.data
        self.data = nil
      end
      _class_0.__parent.__init(self, self.parent, self.data)
      self.data.type = "box"
      if not (self.data.background) then
        self.data.background = background
      end
    end,
    __base = _base_0,
    __name = "box",
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
  box = _class_0
  return _class_0
end
