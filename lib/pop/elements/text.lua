local graphics
graphics = love.graphics
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/box"))
local element = require(tostring(path) .. "/element")
local text
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      graphics.setColor(self.data.color)
      graphics.setFont(self.data.font)
      graphics.print(self.data.text, self.data.x, self.data.y)
      return self
    end,
    debugDraw = function(self)
      graphics.setLineWidth(0.5)
      graphics.setColor(0, 0, 0, 100)
      graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(200, 0, 0, 200)
      graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
      graphics.setColor(255, 200, 200, 255)
      graphics.print("t", self.data.x, self.data.y)
      return self
    end,
    setSize = function(self)
      local w = self.data.font:getWidth(self.data.text)
      local h = self.data.font:getHeight() * (select(2, self.data.text:gsub("\n", "\n")) + 1)
      local _exp_0 = self.data.horizontal
      if "center" == _exp_0 then
        self.data.x = self.data.x - ((w - self.data.w) / 2)
      elseif "right" == _exp_0 then
        self.data.x = self.data.x - (w - self.data.w - self.data.margin)
      end
      local _exp_1 = self.vertical
      if "center" == _exp_1 then
        self.data.y = self.data.y - ((h - self.data.h) / 2)
      elseif "bottom" == _exp_1 then
        self.data.y = self.data.y - (h - self.data.h - self.data.margin)
      end
      self.data.w = w
      self.data.h = h
      return self
    end,
    setWidth = function(self)
      self:setSize()
      return self
    end,
    setHeight = function(self)
      self:setSize()
      return self
    end,
    setText = function(self, text)
      if text == nil then
        text = ""
      end
      self.data.text = text
      self:setSize()
      return self
    end,
    getText = function(self)
      return self.data.text
    end,
    setFont = function(self, font)
      self.data.font = font
      self:setSize()
      return self
    end,
    getFont = function(self)
      return self.data.font
    end,
    setColor = function(self, r, g, b, a)
      if a == nil then
        a = 255
      end
      if type(r) == "table" then
        self.data.color = r
      else
        self.data.color = {
          r,
          g,
          b,
          a
        }
      end
      return self
    end,
    getColor = function(self)
      return unpack(self.data.color)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, text, color)
      if text == nil then
        text = ""
      end
      if color == nil then
        color = {
          255,
          255,
          255,
          255
        }
      end
      if type(text) == "table" then
        _class_0.__parent.__init(self, parent, text)
      else
        _class_0.__parent.__init(self, parent)
      end
      if not self.data.font then
        self.data.font = graphics.newFont(14)
      end
      if not self.data.color then
        self.data.color = color
      end
      if type(text) == "string" then
        return self:setText(text)
      else
        return self:setSize()
      end
    end,
    __base = _base_0,
    __name = "text",
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
  local self = _class_0
  self.wrap = function(pop)
    return function(parent, ...)
      if type(parent) == "string" then
        return pop.create("text", nil, parent, ...)
      else
        return pop.create("text", parent, ...)
      end
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  text = _class_0
  return _class_0
end
