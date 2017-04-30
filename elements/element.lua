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
      if "left" == _exp_0 then
        self.data.x = self.data.x + self.data.padding
      elseif "center" == _exp_0 then
        self.data.x = self.data.x + ((self.parent.data.w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x + (self.parent.data.w - self.data.w - self.data.padding)
      end
      local _exp_1 = self.data.vertical
      if "top" == _exp_1 then
        self.data.y = self.data.y + self.data.padding
      elseif "center" == _exp_1 then
        self.data.y = self.data.y + ((self.parent.data.h - self.data.h) / 2)
      elseif "bottom" == _exp_1 then
        self.data.y = self.data.y + (self.parent.data.h - self.data.h - self.data.padding)
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
        local _exp_0 = self.data.horizontal
        if "center" == _exp_0 then
          self.data.x = self.data.x - (self.data.w / 2)
        elseif "right" == _exp_0 then
          self.data.x = self.data.x - self.data.w
        end
      end
      if y then
        self.data.y = y
        local _exp_0 = self.data.vertical
        if "center" == _exp_0 then
          self.data.y = self.data.y - (self.data.h / 2)
        elseif "bottom" == _exp_0 then
          self.data.y = self.data.y - self.data.h
        end
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
    getPosition = function(self)
      local x, y = self.data.x, self.data.y
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        x = x + (self.data.w / 2)
      elseif "right" == _exp_0 then
        y = y + self.data.w
      end
      local _exp_1 = self.data.vertical
      if "center" == _exp_1 then
        y = y + (self.data.h / 2)
      elseif "bottom" == _exp_1 then
        y = y + self.data.h
      end
      return x, y
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
      self:align()
      return self
    end,
    getWidth = function(self)
      return self.data.w
    end,
    setHeight = function(self, h)
      self.data.h = h
      self:align()
      return self
    end,
    getHeight = function(self)
      return self.data.h
    end,
    adjustSize = function(self, w, h)
      local W, H = self:getSize()
      if w then
        W = W + w
      end
      if h then
        H = H + h
      end
      self:setSize(W, H)
      return self
    end,
    move = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      self.data.x = self.data.x + x
      self.data.y = self.data.y + y
      local _list_0 = self.child
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:move(x, y)
      end
      return self
    end,
    setPadding = function(self, padding)
      self.data.padding = padding
      self:align()
      return self
    end,
    getPadding = function(self)
      return self.data.padding
    end,
    indexOf = function(self, element)
      for i = 1, #self.child do
        if self.child[i] == element then
          return i
        end
      end
    end,
    delete = function(self)
      for i = #self.child, 1, -1 do
        self.child[i]:delete()
      end
      if self.parent then
        for i = 1, #self.parent.child do
          if self.parent.child[i] == self then
            table.remove(self.parent.child, i)
            break
          end
        end
      end
      if self.parent then
        for i = 1, #self.parent.data.child do
          if self.parent.data.child[i] == self.data then
            table.remove(self.parent.data.child, i)
            break
          end
        end
      end
      self.parent = nil
      self.data.parent = nil
      self = nil
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
      if not (self.data.type) then
        self.data.type = "element"
      end
      if not (self.data.x) then
        if self.parent then
          self.data.x = self.parent.data.x
        else
          self.data.x = 0
        end
      end
      if not (self.data.y) then
        if self.parent then
          self.data.y = self.parent.data.y
        else
          self.data.y = 0
        end
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
      if (self.data.align == nil) and self.parent then
        self.data.align = true
      end
      if not (self.data.vertical) then
        self.data.vertical = "top"
      end
      if not (self.data.horizontal) then
        self.data.horizontal = "left"
      end
      if not (self.data.padding) then
        self.data.padding = 0
      end
      self.child = { }
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
