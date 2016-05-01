local graphics
graphics = love.graphics
local floor
floor = math.floor
local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local tonumber = tonumber
local element
do
  local _class_0
  local _base_0 = {
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(0, 200, 0, 200)
      graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(200, 255, 200, 255)
      graphics.print("e", self.data.x, self.data.y)
      return self
    end,
    addChild = function(self, child)
      if child.data.parent then
        child.data.parent:removeChild(child)
      end
      insert(self.data.child, child)
      child.data.parent = self
      child:align()
      return self
    end,
    removeChild = function(self, child)
      if tonumber(child) == child then
        self.data.child[child].data.parent = false
        return remove(self.data.child, child)
      else
        for k, v in ipairs(self.data.child) do
          if v == child then
            return remove(self.data.child, k)
          end
        end
        return "Element \"" .. tostring(child) .. "\" is not a child of element \"" .. tostring(self) .. "\". Cannot remove it."
      end
    end,
    getChildren = function(self)
      return self.data.child
    end,
    move = function(self, x, y)
      if x then
        self.data.x = self.data.x + x
      end
      if y then
        self.data.y = self.data.y + y
      end
      for i = 1, #self.data.child do
        if self.data.child[i].data.move then
          self.data.child[i]:move(x, y)
        end
      end
      return self
    end,
    setPosition = function(self, x, y)
      local oldX = self.data.x
      local oldY = self.data.y
      if x then
        local _exp_0 = self.data.horizontal
        if "left" == _exp_0 then
          self.data.x = x
        elseif "center" == _exp_0 then
          self.data.x = x - self.data.w / 2
        elseif "right" == _exp_0 then
          self.data.x = x - self.data.w
        end
      else
        x = oldX
      end
      if y then
        local _exp_0 = self.data.vertical
        if "top" == _exp_0 then
          self.data.y = y
        elseif "center" == _exp_0 then
          self.data.y = y - self.data.h / 2
        elseif "bottom" == _exp_0 then
          self.data.y = y - self.data.h
        end
      else
        y = oldY
      end
      for i = 1, #self.data.child do
        self.data.child[i]:move(x - oldX, y - oldY)
      end
      return self
    end,
    getPosition = function(self)
      local resultX = self.data.x
      local resultY = self.data.y
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        resultX = resultX + (self.data.w / 2)
      elseif "right" == _exp_0 then
        resultY = resultY + self.data.w
      end
      local _exp_1 = self.data.vertical
      if "center" == _exp_1 then
        resultY = resultY + (self.data.h / 2)
      elseif "bottom" == _exp_1 then
        resultY = resultY + self.data.h
      end
      return resultX, resultY
    end,
    setSize = function(self, w, h)
      if w then
        local _exp_0 = self.data.horizontal
        if "center" == _exp_0 then
          self.data.x = self.data.x - ((w - self.data.w) / 2)
        elseif "right" == _exp_0 then
          self.data.x = self.data.x - (w - self.data.w)
        end
        self.data.w = w
      end
      if h then
        local _exp_0 = self.data.vertical
        if "center" == _exp_0 then
          self.data.y = self.data.y - ((h - self.data.h) / 2)
        elseif "bottom" == _exp_0 then
          self.data.y = self.data.y - (h - self.data.h)
        end
        self.data.h = h
      end
      return self
    end,
    getSize = function(self)
      return self.data.w, self.data.h
    end,
    setWidth = function(self, w)
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        self.data.x = self.data.x - ((w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x - (w - self.data.w)
      end
      self.data.w = w
      return self
    end,
    getWidth = function(self)
      return self.data.w
    end,
    setHeight = function(self, h)
      local _exp_0 = self.data.vertical
      if "center" == _exp_0 then
        self.data.y = self.data.y - ((h - self.data.h) / 2)
      elseif "bottom" == _exp_0 then
        self.data.y = self.data.y - (h - self.data.h)
      end
      self.data.h = h
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
    align = function(self, horizontal, vertical, toPixel)
      if toPixel == nil then
        toPixel = true
      end
      self:setAlignment(horizontal, vertical)
      self.data.x = self.data.parent.data.x
      self.data.y = self.data.parent.data.y
      local _exp_0 = self.data.horizontal
      if "left" == _exp_0 then
        self.data.x = self.data.x + self.data.margin
      elseif "center" == _exp_0 then
        self.data.x = self.data.x + ((self.data.parent.data.w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x + (self.data.parent.data.w - self.data.w - self.data.margin)
      end
      local _exp_1 = self.data.vertical
      if "top" == _exp_1 then
        self.data.y = self.data.y + self.data.margin
      elseif "center" == _exp_1 then
        self.data.y = self.data.y + ((self.data.parent.data.h - self.data.h) / 2)
      elseif "bottom" == _exp_1 then
        self.data.y = self.data.y + (self.data.parent.data.h - self.data.h - self.data.margin)
      end
      if toPixel then
        self.data.x = floor(self.data.x)
        self.data.y = floor(self.data.y)
      end
      return self
    end,
    alignTo = function(self, element, horizontal, vertical, toPixel)
      if toPixel == nil then
        toPixel = true
      end
      local parent = self.data.parent
      self.data.parent = element
      self:align(horizontal, vertical, toPixel)
      self.data.parent = parent
      return self
    end,
    setAlignment = function(self, horizontal, vertical)
      if horizontal then
        self.data.horizontal = horizontal
      end
      if vertical then
        self.data.vertical = vertical
      end
      return self
    end,
    getAlignment = function(self)
      return self.data.horizontal, self.data.vertical
    end,
    setMargin = function(self, margin)
      self.data.margin = margin
      self:align()
      return self
    end,
    getMargin = function(self)
      return self.data.margin
    end,
    fill = function(self)
      self.data.x = self.data.parent.data.x + self.data.margin
      self.data.y = self.data.parent.data.y + self.data.margin
      self.data.w = self.data.parent.data.w - self.data.margin * 2
      self.data.h = self.data.parent.data.h - self.data.margin * 2
    end,
    delete = function(self)
      for k, v in ipairs(self.data.child) do
        v:delete()
      end
      self.data.parent:removeChild(self)
      self = nil
      return nil
    end,
    getVisibility = function(self)
      return self.data.draw
    end,
    setVisibility = function(self, isVisible)
      self.data.draw = isVisible
      return self
    end,
    getStatic = function(self)
      return (not self.data.move)
    end,
    setStatic = function(self, isStatic)
      self.data.move = (not isStatic)
      return self
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.data = {
        parent = parent,
        child = { },
        w = 0,
        h = 0,
        x = 0,
        y = 0,
        horizontal = "left",
        vertical = "top",
        margin = 0,
        draw = true,
        update = true,
        move = true
      }
      if parent then
        self.data.x = parent.data.x
        self.data.y = parent.data.y
      end
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
