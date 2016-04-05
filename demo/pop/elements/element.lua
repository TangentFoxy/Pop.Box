local graphics
graphics = love.graphics
local floor
floor = math.floor
local element
do
  local _class_0
  local _base_0 = {
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.x, self.y, self.w, self.h)
      graphics.setColor(0, 200, 0, 200)
      graphics.rectangle("line", self.x, self.y, self.w, self.h)
      graphics.setColor(200, 255, 200, 255)
      graphics.print("e", self.x, self.y)
      return self
    end,
    addChild = function(self, child)
      self.child[#self.child + 1] = child
      child.parent = self
      return self
    end,
    getChildren = function(self)
      return self.child
    end,
    move = function(self, x, y)
      if x then
        self.x = self.x + x
      end
      if y then
        self.y = self.y + y
      end
      for i = 1, #self.child do
        if not (self.child[i].excludeMovement) then
          self.child[i]:move(x, y)
        end
      end
      return self
    end,
    setPosition = function(self, x, y)
      local oldX = self.x
      local oldY = self.y
      if x then
        local _exp_0 = self.horizontal
        if "left" == _exp_0 then
          self.x = x
        elseif "center" == _exp_0 then
          self.x = x - self.w / 2
        elseif "right" == _exp_0 then
          self.x = x - self.w
        end
      else
        x = oldX
      end
      if y then
        local _exp_0 = self.vertical
        if "top" == _exp_0 then
          self.y = y
        elseif "center" == _exp_0 then
          self.y = y - self.h / 2
        elseif "bottom" == _exp_0 then
          self.y = y - self.h
        end
      else
        y = oldY
      end
      for i = 1, #self.child do
        if not (self.child[i].excludeMovement) then
          self.child[i]:move(x - oldX, y - oldY)
        end
      end
      return self
    end,
    getPosition = function(self)
      local resultX = self.x
      local resultY = self.y
      local _exp_0 = self.horizontal
      if "center" == _exp_0 then
        resultX = resultX + (self.w / 2)
      elseif "right" == _exp_0 then
        resultY = resultY + self.w
      end
      local _exp_1 = self.vertical
      if "center" == _exp_1 then
        resultY = resultY + (self.h / 2)
      elseif "bottom" == _exp_1 then
        resultY = resultY + self.h
      end
      return resultX, resultY
    end,
    setSize = function(self, w, h)
      if w then
        local _exp_0 = self.horizontal
        if "center" == _exp_0 then
          self.x = self.x - ((w - self.w) / 2)
        elseif "right" == _exp_0 then
          self.x = self.x - (w - self.w)
        end
        self.w = w
      end
      if h then
        local _exp_0 = self.vertical
        if "center" == _exp_0 then
          self.y = self.y - ((h - self.h) / 2)
        elseif "bottom" == _exp_0 then
          self.y = self.y - (h - self.h)
        end
        self.h = h
      end
      return self
    end,
    getSize = function(self)
      return self.w, self.h
    end,
    setWidth = function(self, w)
      local _exp_0 = self.horizontal
      if "center" == _exp_0 then
        self.x = self.x - ((w - self.w) / 2)
      elseif "right" == _exp_0 then
        self.x = self.x - (w - self.w)
      end
      self.w = w
      return self
    end,
    getWidth = function(self)
      return self.w
    end,
    setHeight = function(self, h)
      local _exp_0 = self.vertical
      if "center" == _exp_0 then
        self.y = self.y - ((h - self.h) / 2)
      elseif "bottom" == _exp_0 then
        self.y = self.y - (h - self.h)
      end
      self.h = h
      return self
    end,
    getHeight = function(self)
      return self.h
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
    align = function(self, horizontal, vertical, toPixel)
      self:setAlignment(horizontal, vertical)
      self.x = self.parent.x
      self.y = self.parent.y
      local _exp_0 = self.horizontal
      if "left" == _exp_0 then
        self.x = self.x + self.margin
      elseif "center" == _exp_0 then
        self.x = self.x + ((self.parent.w - self.w) / 2)
      elseif "right" == _exp_0 then
        self.x = self.x + (self.parent.w - self.w - self.margin)
      end
      local _exp_1 = self.vertical
      if "top" == _exp_1 then
        self.y = self.y + self.margin
      elseif "center" == _exp_1 then
        self.y = self.y + ((self.parent.h - self.h) / 2)
      elseif "bottom" == _exp_1 then
        self.y = self.y + (self.parent.h - self.h - self.margin)
      end
      if toPixel or (toPixel == nil) then
        self.x = floor(self.x)
        self.y = floor(self.y)
      end
      return self
    end,
    alignTo = function(self, element, horizontal, vertical)
      local parent = self.parent
      self.parent = element
      self:align(horizontal, vertical)
      self.parent = parent
      return self
    end,
    setAlignment = function(self, horizontal, vertical)
      if horizontal then
        self.horizontal = horizontal
      end
      if vertical then
        self.vertical = vertical
      end
      return self
    end,
    getAlignment = function(self)
      return self.horizontal, self.vertical
    end,
    setMargin = function(self, margin)
      self.margin = margin
      self:align()
      return self
    end,
    getMargin = function(self)
      return self.margin
    end,
    fill = function(self)
      self.x = self.parent.x + self.margin
      self.y = self.parent.y + self.margin
      self.w = self.parent.w - self.margin * 2
      self.h = self.parent.h - self.margin * 2
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.child = { }
      self.w = 0
      self.h = 0
      self.margin = 0
      if parent then
        self.x = parent.x
        self.y = parent.y
      else
        self.x = 0
        self.y = 0
      end
      self.horizontal = "left"
      self.vertical = "top"
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
