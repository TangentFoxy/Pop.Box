local graphics
graphics = love.graphics
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/window"))
local element = require(tostring(path) .. "/element")
local box = require(tostring(path) .. "/box")
local text = require(tostring(path) .. "/text")
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
    print("elements/window: unrecognized LÖVE version: " .. tostring(major) .. "." .. tostring(minor) .. "." .. tostring(revision))
    print("                 assuming LÖVE version > 0.10.1  (there may be bugs)")
  end
end
local pop_ref = false
local window
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    load = function(pop)
      pop_ref = pop
    end,
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.x, self.y, self.w, self.h)
      graphics.setColor(200, 0, 200, 200)
      graphics.rectangle("line", self.x, self.y, self.w, self.h)
      graphics.setColor(255, 200, 255, 255)
      graphics.print("w", self.x, self.y)
      return self
    end,
    addChild = function(self, child)
      self.window.child[#self.window.child + 1] = child
      child.parent = self.window
      return self
    end,
    getChildren = function(self)
      return self.window.child
    end,
    align = function(self, horizontal, vertical, toPixel)
      _class_0.__parent.__base.align(self, horizontal, vertical, toPixel)
      for i = 1, #self.child do
        self.child[i]:align()
      end
      self.window:move(nil, self.head:getHeight())
      return self
    end,
    setSize = function(self, w, h)
      local x = 0
      local y = 0
      if w then
        local _exp_0 = self.horizontal
        if "center" == _exp_0 then
          x = x - ((w - self.w) / 2)
        elseif "right" == _exp_0 then
          x = x - (w - self.w)
        end
        self.head:setWidth(w)
        self.window:setWidth(w)
        self.w = w
        self.x = self.x + x
        self.title:align()
      end
      if h then
        h = h - self.head:getHeight()
        local _exp_0 = self.vertical
        if "center" == _exp_0 then
          y = y - ((h - self.h) / 2)
        elseif "right" == _exp_0 then
          y = y - (h - self.h)
        end
        self.window:setHeight(h)
        self.h = h + self.head:getHeight()
        self.y = self.y + y
      end
      self.head:move(x, y)
      self.window:move(x, y)
      return self
    end,
    setWidth = function(self, w)
      local x = 0
      local _exp_0 = self.horizontal
      if "center" == _exp_0 then
        x = x - ((w - self.w) / 2)
      elseif "right" == _exp_0 then
        x = x - (w - self.w)
      end
      self.head:setWidth(w)
      self.window:setWidth(w)
      self.w = w
      self.x = self.x + x
      self.title:align()
      self.head:move(x)
      self.window:move(x)
      return self
    end,
    setHeight = function(self, h)
      local y = 0
      h = h - self.head:getHeight()
      local _exp_0 = self.vertical
      if "center" == _exp_0 then
        y = y - ((h - self.h) / 2)
      elseif "right" == _exp_0 then
        y = y - (h - self.h)
      end
      self.window:setHeight(h)
      self.h = h + self.head:getHeight()
      self.y = self.y + y
      self.head:move(nil, y)
      self.title:move(nil, y)
      self.window:move(nil, y)
      return self
    end,
    setTitle = function(self, title)
      self.title:setText(title)
      return self
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
      self.head = box(self, tBackground)
      self.title = text(self, title, tColor)
      self.window = box(self, wBackground)
      local height = self.title:getHeight()
      self.head:setSize(self.w, height)
      self.window:move(nil, height)
      self:setSize(100, 80)
      self.child = {
        self.head,
        self.title,
        self.window
      }
      self.head.selected = false
      if mousemoved_event then
        self.head.mousemoved = function(self, x, y, dx, dy)
          if self.selected then
            self.parent:move(y, dx)
            return true
          end
          return false
        end
        self.head.mousepressed = function(self, x, y, button)
          if button == left then
            self.selected = true
            return true
          end
          return false
        end
        self.head.mousereleased = function(self, x, y, button)
          if button == left then
            self.selected = false
            pop_ref.focused = false
            return true
          end
          return false
        end
      else
        self.head.mx = 0
        self.head.my = 0
        self.head.update = function(self)
          return false
        end
        self.head.mousepressed = function(self, x, y, button)
          if button == left then
            self.selected = true
            self.mx = x
            self.my = y
          end
        end
        self.head.mousereleased = function(self, x, y, button)
          if button == left then
            self.selected = false
            return true
          end
          return false
        end
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
