local graphics
graphics = love.graphics
local floor
floor = math.floor
local element
do
  local _class_0
  local _base_0 = {
    debugDraw = function(self)
      graphics.setLineWidth(1)
      graphics.setColor(0, 20, 0, 100)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(150, 255, 150, 150)
      graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(200, 255, 200, 255)
      return graphics.print("e", self.data.x, self.data.y)
    end,
    align = function(self, horizontal, vertical, toPixel)
      if toPixel == nil then
        toPixel = true
      end
      if not (self.data.align) then
        return false
      end
      if horizontal then
        self.data.horizontal = horizontal
      end
      if vertical then
        self.data.vertical = vertical
      end
      self.data.x = self.parent.data.x
      self.data.y = self.parent.data.y
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        self.data.x = self.data.x + ((self.parent.data.w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x + (self.parent.data.w - self.data.w)
      end
      local _exp_1 = self.data.vertical
      if "center" == _exp_1 then
        self.data.y = self.data.y + ((self.parent.data.h - self.data.h) / 2)
      elseif "bottom" == _exp_1 then
        self.data.y = self.data.y + (self.parent.data.h - self.data.h)
      end
      if toPixel then
        self.data.x = floor(self.data.x)
        self.data.y = floor(self.data.y)
      end
      return self
    end,
    setSize = function(self, w, h)
      if w then
        self.data.w = w
      end
      if h then
        self.data.h = h
      end
      return self
    end,
    getSize = function(self)
      return self.data.w, self.data.h
    end,
    setWidth = function(self, w)
      self.data.w = w
      return self
    end,
    getWidth = function(self)
      return self.data.w
    end,
    setHeight = function(self, h)
      self.data.h = h
      return self
    end,
    getHeight = function(self)
      return self.data.h
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent, data)
      if data == nil then
        data = { }
      end
      self.parent, self.data = parent, data
      if type(self.data) ~= "table" then
        self.data = { }
      end
      if not (self.data.parent) then
        self.data.parent = false
      end
      if not (self.data.child) then
        self.data.child = { }
      end
      if not (self.data.x) then
        self.data.x = 0
      end
      if not (self.data.y) then
        self.data.y = 0
      end
      if not (self.data.w) then
        self.data.w = 0
      end
      if not (self.data.h) then
        self.data.h = 0
      end
      if self.data.update == nil then
        self.data.update = false
      end
      if self.data.draw == nil then
        self.data.draw = true
      end
      if not (self.data.type) then
        self.data.type = "element"
      end
      if (self.data.align == nil) and self.parent then
        self.data.align = true
      end
      if not (self.data.vertical) then
        self.data.vertical = "top"
      end
      if not (self.data.horizontal) then
        self.data.horizontal = "left"
      end
      self.child = { }
      return self:align()
    end,
    __base = _base_0,
    __name = "element"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  element = _class_0
  return _class_0
end
