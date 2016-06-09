local graphics
graphics = love.graphics
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/box"))
local element = require(tostring(path) .. "/element")
local box
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      if self.data.background then
        if type(self.data.background) == "table" then
          graphics.setColor(self.data.background)
          graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
        else
          local w, h = self.data.background:getDimensions()
          w = self.data.w / w
          h = self.data.h / h
          graphics.setColor(255, 255, 255, 255)
          graphics.draw(self.data.background, self.data.x, self.data.y, 0, w, h)
        end
      end
      return self
    end,
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(0, 0, 200, 200)
      graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(200, 200, 255, 255)
      graphics.print("b", self.data.x, self.data.y)
      return self
    end,
    setBackground = function(self, background)
      self.data.background = background
      return self
    end,
    getBackground = function(self)
      return self.data.background
    end,
    setColor = function(self, r, g, b, a)
      if a == nil then
        a = 255
      end
      if type(r) == "table" then
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
      if type(self.data.background) == "table" then
        return unpack(self.data.background)
      else
        return error("Box \"" .. tostring(self) .. "\" doesn't have a color.")
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, background)
      if background == nil then
        background = false
      end
      if type(background) == "table" then
        for k, v in pairs(background) do
          if type(k) ~= "number" then
            _class_0.__parent.__init(self, parent, background)
            if not background.w then
              self.data.w = 20
            end
            if not background.h then
              self.data.h = 20
            end
            if self.data.background == nil then
              self.data.background = false
            end
            return 
          end
        end
      else
        _class_0.__parent.__init(self, parent)
        if not self.data.w then
          self.data.w = 20
        end
        if not self.data.h then
          self.data.h = 20
        end
        if not self.data.background then
          self.data.background = background
        end
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
