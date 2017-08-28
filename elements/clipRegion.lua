local graphics
graphics = love.graphics
local element = require(tostring((...):sub(1, -11)) .. "/element")
local recursiveDraw
recursiveDraw = function(children, x, y)
  for i = 1, #children do
    local child = children[i]
    local drawChildren
    if child.draw then
      child.data.x = child.data.x - x
      child.data.y = child.data.y - y
      drawChildren = child:draw()
      child.data.x = child.data.x + x
      child.data.y = child.data.y + y
    end
    if drawChildren ~= false then
      recursiveDraw(child.child, x, y)
    end
  end
end
local canvasDraw
local major, minor = love.getVersion()
if major == 0 and minor == 10 then
  canvasDraw = function(canvas, x, y)
    return graphics.draw(canvas, x, y)
  end
else
  canvasDraw = function(canvas, x, y)
    local mode, alpha = graphics.getBlendMode()
    graphics.setBlendMode("alpha", "premultiplied")
    graphics.draw(canvas, x, y)
    return graphics.setBlendMode(mode, alpha)
  end
end
local clipRegion
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    draw = function(self)
      graphics.setCanvas(self.canvas)
      graphics.clear()
      recursiveDraw(self.child, self.data.x, self.data.y)
      graphics.setCanvas()
      graphics.setColor(255, 255, 255, 255)
      canvasDraw(self.canvas, self.data.x, self.data.y)
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, data)
      if data == nil then
        data = { }
      end
      self.parent, self.data = parent, data
      _class_0.__parent.__init(self, self.parent, self.data)
      if self.data.type == "element" then
        self.data.type = "clipRegion"
      end
      self.canvas = graphics.newCanvas(self.data.w, self.data.h)
    end,
    __base = _base_0,
    __name = "clipRegion",
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
  clipRegion = _class_0
  return _class_0
end
