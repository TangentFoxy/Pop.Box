local graphics
graphics = love.graphics
local floor
floor = math.floor
local element
do
  local _class_0
  local _base_0 = {
    align = function(self, horizontal, vertical, toPixel)
      if toPixel == nil then
        toPixel = true
      end
      if not (self.data.align) then
        return self
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
    setPosition = function(self, x, y, toPixel)
      if toPixel == nil then
        toPixel = true
      end
      local dx, dy = self.data.x, self.data.y
      if x then
        self.data.x = x
      end
      if y then
        self.data.y = y
      end
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        self.data.x = self.data.x - (self.data.w / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x - self.data.w
      end
      local _exp_1 = self.data.vertical
      if "center" == _exp_1 then
        self.data.y = self.data.y - (self.data.h / 2)
      elseif "bottom" == _exp_1 then
        self.data.y = self.data.y - self.data.h
      end
      if toPixel then
        self.data.x = floor(self.data.x)
        self.data.y = floor(self.data.y)
      end
      dx = self.data.x - dx
      dy = self.data.y - dy
      local _list_0 = self.child
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:move(dx, dy)
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
      self:align()
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
    end,
    move = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      local _list_0 = self.child
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:move(x, y)
      end
      self.data.x = self.data.x + x
      self.data.y = self.data.y + y
      return self
    end,
    delete = function(self)
      for i = #self.child, 1, -1 do
        self.child[i]:delete()
      end
      for i = 1, #self.parent.child do
        if self.parent.child[i] == self then
          table.remove(self.parent.child, i)
          break
        end
      end
      for i = 1, #self.parent.data.child do
        if self.parent.data.child[i] == self.data then
          table.remove(self.parent.data.child, i)
          break
        end
      end
      self.parent = nil
      self.data.parent = nil
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
        self.data.update = true
      end
      if self.data.draw == nil then
        self.data.draw = true
      end
      if self.data.hoverable == nil then
        self.data.hoverable = true
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
