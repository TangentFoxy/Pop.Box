local graphics, mouse
do
  local _obj_0 = love
  graphics, mouse = _obj_0.graphics, _obj_0.mouse
end
local insert, remove
do
  local _obj_0 = table
  insert, remove = _obj_0.insert, _obj_0.remove
end
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/window"))
local element = require(tostring(path) .. "/element")
local box = require(tostring(path) .. "/box")
local text = require(tostring(path) .. "/text")
local closeImage = graphics.newImage(tostring(path) .. "/img/close.png")
local left = 1
local mousemoved_event = true
do
  local major, minor, revision = love.getVersion()
  if (major == 0) and (minor == 10) and ((revision == 0) or (revision == 1)) then
    left = 1
  elseif (major == 0) and (minor == 9) then
    left = "l"
    if revision == 1 then
      mousemoved_event = false
    end
  else
    print("elements/window: unrecognized LOVE version: " .. tostring(major) .. "." .. tostring(minor) .. "." .. tostring(revision))
    print("                 assuming LOVE version > 0.10.1  (there may be bugs)")
  end
end
local window
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(200, 0, 200, 200)
      graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(255, 200, 255, 255)
      graphics.print("w", self.data.x, self.data.y)
      return self
    end,
    addChild = function(self, child)
      self.data.area:addChild(child)
      return self
    end,
    removeChild = function(self, child)
      local result = self.data.area:removeChild(child)
      if result == self.data.area then
        return self
      elseif type(result) == "string" then
        for k, v in ipairs(self.data.child) do
          if v == child then
            remove(self.data.child, k)
            return self
          end
        end
        return "Element \"" .. tostring(child) .. "\" is not a child of window \"" .. tostring(self) .. "\". Cannot remove it."
      else
        return result
      end
    end,
    getChildren = function(self)
      return self.data.area.child
    end,
    align = function(self, horizontal, vertical, toPixel)
      _class_0.__parent.__base.align(self, horizontal, vertical, toPixel)
      for i = 1, #self.data.child do
        self.data.child[i]:align()
      end
      self.data.area:move(nil, self.data.head:getHeight())
      return self
    end,
    setSize = function(self, w, h)
      local x = 0
      local y = 0
      if w then
        local _exp_0 = self.data.horizontal
        if "center" == _exp_0 then
          x = x - ((w - self.data.w) / 2)
        elseif "right" == _exp_0 then
          x = x - (w - self.data.w)
        end
        if self.data.close then
          self.data.head:setWidth(w - self.data.head:getHeight())
        else
          self.data.head:setWidth(w)
        end
        self.data.area:setWidth(w)
        self.data.w = w
        self.data.x = self.data.x + x
        self.data.title:align()
        if self.data.close then
          self.data.close:align()
        end
      end
      if h then
        h = h - self.data.head:getHeight()
        local _exp_0 = self.data.vertical
        if "center" == _exp_0 then
          y = y - ((h - self.data.h) / 2)
        elseif "right" == _exp_0 then
          y = y - (h - self.data.h)
        end
        self.data.area:setHeight(h)
        self.data.h = h + self.data.head:getHeight()
        self.data.y = self.data.y + y
      end
      self.data.head:move(x, y)
      self.data.area:move(x, y)
      return self
    end,
    setWidth = function(self, w)
      local x = 0
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        x = x - ((w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        x = x - (w - self.data.w)
      end
      if self.data.close then
        self.data.head:setWidth(w - self.data.head:getHeight())
      else
        self.data.head:setWidth(w)
      end
      self.data.area:setWidth(w)
      self.data.w = w
      self.data.x = self.data.x + x
      self.data.title:align()
      if self.data.close then
        self.data.close:align()
      end
      self.data.head:move(x)
      self.data.area:move(x)
      return self
    end,
    setHeight = function(self, h)
      local y = 0
      h = h - self.data.head:getHeight()
      local _exp_0 = self.data.vertical
      if "center" == _exp_0 then
        y = y - ((h - self.data.h) / 2)
      elseif "right" == _exp_0 then
        y = y - (h - self.data.h)
      end
      self.data.area:setHeight(h)
      self.data.h = h + self.data.head:getHeight()
      self.data.y = self.data.y + y
      self.data.head:move(nil, y)
      self.data.title:move(nil, y)
      self.data.area:move(nil, y)
      return self
    end,
    setTitle = function(self, title)
      self.data.title:setText(title)
      if self.data.overflow == "trunicate" then
        while self.data.title:getWidth() > self.data.head:getWidth() do
          title = title:sub(1, -3)
          self.data.title:setText(title .. "…")
        end
      elseif self.data.overflow == "resize" then
        if self.data.title:getWidth() > self.data.head:getWidth() then
          self:setWidth(self.data.title:getWidth())
        end
      end
      return self
    end,
    getTitle = function(self)
      return self.data.title:getText()
    end,
    setTitleOverflow = function(self, method)
      self.data.overflow = method
      return self
    end,
    getTitleOverflow = function(self)
      return self.data.overflow
    end,
    setClose = function(self, enabled)
      if enabled then
        self.data.close = box(self, closeImage)
        self.data.close.clicked = function()
          self:delete()
          return true
        end
        local height = self.data.head:getHeight()
        self.data.close:align("right"):setSize(height, height)
        self.data.head:setWidth(self.data.w - height)
        self.data.title:align()
        insert(self.data.child, self.data.close)
      else
        self.data.close:delete()
        self.data.head:setWidth(self.data.w)
        self.data.title:align()
        self.data.close = false
      end
      return self
    end,
    hasClose = function(self)
      if self.data.close then
        return true
      else
        return false
      end
    end,
    delete = function(self)
      _class_0.__parent.__base.delete(self)
      self.data.head = nil
      self.data.title = nil
      self.data.area = nil
      self.data.close = nil
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, title, tBackground, tColor, wBackground)
      if title == nil then
        title = "window"
      end
      if tBackground == nil then
        tBackground = {
          25,
          180,
          230,
          255
        }
      end
      if tColor == nil then
        tColor = {
          255,
          255,
          255,
          255
        }
      end
      if wBackground == nil then
        wBackground = {
          200,
          200,
          210,
          255
        }
      end
      _class_0.__parent.__init(self, parent)
      self.data.head = box(self, tBackground)
      self.data.title = text(self.data.head, title, tColor)
      self.data.area = box(self, wBackground)
      self.data.close = box(self, closeImage)
      local height = self.data.title:getHeight()
      self.data.head:setSize(self.data.w - height, height)
      self.data.area:move(nil, height)
      self.data.close:align("right"):setSize(height, height)
      self:setSize(100, 80)
      self.data.child = {
        self.data.head,
        self.data.title,
        self.data.area,
        self.data.close
      }
      self.data.overflow = "trunicate"
      self.data.area.mousepressed = function()
        return true
      end
      self.data.area.clicked = function()
        return true
      end
      self.data.close.clicked = function()
        self:delete()
        return true
      end
      self.data.head.data.selected = false
      if mousemoved_event then
        self.data.head.mousemoved = function(self, x, y, dx, dy)
          if self.data.selected then
            self.data.parent:move(dx, dy)
            return true
          end
          return false
        end
        self.data.head.mousepressed = function(self, x, y, button)
          if button == left then
            self.data.selected = true
            return true
          end
          return false
        end
      else
        self.data.head.data.mx = 0
        self.data.head.data.my = 0
        self.data.head.update = function(self)
          local x, y = mouse.getPosition()
          return self:setPosition(x - self.data.mx, y - self.data.my)
        end
        self.data.head.mousepressed = function(self, x, y, button)
          if button == left then
            self.data.selected = true
            self.data.mx = x
            self.data.my = y
            return true
          end
          return false
        end
      end
      self.data.head.mousereleased = function(self, x, y, button)
        if button == left then
          self.data.selected = false
          return true
        end
        return false
      end
    end,
    __base = _base_0,
    __name = "window",
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
  window = _class_0
  return _class_0
end
