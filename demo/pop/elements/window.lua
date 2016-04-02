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
local move_event = true
do
  local major, minor, revision = love.getVersion()
  if (major == 0) and (minor == 10) and ((revision == 0) or (revision == 1)) then
    left = 1
  end
  if (major == 0) and (minor == 9) then
    left = "l"
    if revision == 1 then
      move_event = false
    end
  else
    print("elements/window: unrecognized LÖVE version: " .. tostring(major) .. "." .. tostring(minor) .. "." .. tostring(revision))
    print("                 assuming LÖVE version > 0.10.1  (there may be bugs)")
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
      graphics.rectangle("fill", self.x, self.y, self.w, self.h)
      graphics.setColor(200, 0, 200, 200)
      graphics.rectangle("line", self.x, self.y, self.w, self.h)
      graphics.setColor(255, 200, 255, 255)
      graphics.print("w", self.x, self.y)
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
      self.title:move(x, y)
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
      self.head:move(x)
      self.title:move(x)
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
      self.head:move(x, y)
      self.title:move(x, y)
      self.window:move(x, y)
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
