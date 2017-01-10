local graphics
graphics = love.graphics
local element = require(tostring((...):sub(1, -5)) .. "/element")
local text
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      graphics.setColor(self.data.color)
      graphics.setFont(self.font)
      graphics.print(self.data.text, self.data.x, self.data.y)
      return self
    end,
    setSize = function(self)
      self.data.w = self.font:getWidth(self.data.text)
      self.data.h = self.font:getHeight() * (select(2, self.data.text:gsub("\n", "\n")) + 1)
      return self
    end,
    setText = function(self, text)
      self.data.text = text
      return self:setSize()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, data, text, fontFile, fontSize)
      if data == nil then
        data = { }
      end
      if text == nil then
        text = ""
      end
      if fontSize == nil then
        fontSize = 14
      end
      self.parent, self.data = parent, data
      _class_0.__parent.__init(self, self.parent, self.data)
      self.data.type = "text"
      self.data.text = text
      self.data.fontFile = fontFile
      self.data.fontSize = fontSize
      if not (self.data.color) then
        self.data.color = {
          255,
          255,
          255,
          255
        }
      end
      if self.data.fontFile then
        self.font = graphics.newFont(self.data.fontFile, self.data.fontSize)
      else
        self.font = graphics.newFont(self.data.fontSize)
      end
      return self:setSize()
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
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  text = _class_0
  return _class_0
end
