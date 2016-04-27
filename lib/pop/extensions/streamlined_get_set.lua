local graphics
graphics = love.graphics
local sub, len
do
  local _obj_0 = string
  sub, len = _obj_0.sub, _obj_0.len
end
local path = sub(..., 1, len(...) - len("/extensions/streamlined_get_set"))
local element = require(tostring(path) .. "/elements/element")
local box = require(tostring(path) .. "/elements/box")
local text = require(tostring(path) .. "/elements/text")
element.__base.position = function(self, x, y)
  if x or y then
    return self:setPosition(x, y)
  else
    return self:getPosition()
  end
end
element.__base.size = function(self, w, h)
  if w or h then
    return self:setSize(w, h)
  else
    return self:getSize()
  end
end
element.__base.width = function(self, w)
  if w then
    return self:setWidth(w)
  else
    return self:getWidth()
  end
end
element.__base.height = function(self, h)
  if h then
    return self:setHeight(h)
  else
    return self:getHeight()
  end
end
element.__base.alignment = function(self, horizontal, vertical)
  if horizontal or vertical then
    return self:setAlignment(horizontal, vertical)
  else
    return self:getAlignment()
  end
end
element.__base.margin = function(self, m)
  if m then
    return self:setMargin(m)
  else
    return self:getMargin()
  end
end
element.__base.resize = element.__base.adjustSize
element.__base.visibility = function(self, v)
  if v ~= nil then
    return self:setVisibility(v)
  else
    return self:getVisibility()
  end
end
element.__base.show = function(self)
  return self:setVisibility(true)
end
element.__base.hide = function(self)
  return self:setVisibility(false)
end
element.__base.static = function(self, s)
  if s ~= nil then
    return self:setStatic(s)
  else
    return self:getStatic()
  end
end
box.__base.color = function(self, r, g, b, a)
  if r or g or b or a then
    return self:setColor(r, g, b, a)
  else
    return self:getColor()
  end
end
text.__base.text = function(self, text)
  if text then
    return self:setText(text)
  else
    return self:getText()
  end
end
text.__base.font = function(self, font)
  if font then
    return self:setFont(font)
  else
    return self:getFont()
  end
end
text.__base.color = function(self, r, g, b, a)
  if r or g or b or a then
    return self:setColor(r, g, b, a)
  else
    return self:getColor()
  end
end
