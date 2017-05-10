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
    getText = function(self)
      return self.data.text
    end,
    setText = function(self, text)
      self.data.text = tostring(text)
      self:setSize()
      return self:align()
    end,
    setColor = function(self, r, g, b, a)
      if "table" == type(r) then
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
      if "number" == type(text) then
        fontSize = fontFile
        fontFile = text
        text = ""
      end
      if self.data.type == "element" then
        self.data.type = "text"
      end
      if not (self.data.text) then
        self.data.text = text
      end
      if not (self.data.fontFile) then
        self.data.fontFile = fontFile
      end
      if not (self.data.fontSize) then
        self.data.fontSize = fontSize
      end
      if not (self.data.color) then
        self.data.color = {
          255,
          255,
          255,
          255
        }
      end
      if "string" == type(self.data.fontFile) then
        self.font = graphics.newFont(self.data.fontFile, self.data.fontSize)
      elseif "number" == type(self.data.fontFile) then
        self.font = graphics.newFont(self.data.fontFile)
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
