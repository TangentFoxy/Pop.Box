local filesystem, graphics
do
  local _obj_0 = love
  filesystem, graphics = _obj_0.filesystem, _obj_0.graphics
end
local insert
insert = table.insert
local path = ...
local pop = { }
pop.elements = { }
pop.window = {
  child = { }
}
pop.load = function()
  local elements = filesystem.getDirectoryItems(tostring(path) .. "/elements")
  for i = 1, #elements do
    local name = elements[i]:sub(1, -5)
    pop.elements[name] = require(tostring(path) .. "/elements/" .. tostring(name))
    print("loaded element: " .. tostring(name))
    if not pop[name] then
      pop[name] = function(...)
        return pop.create(name, ...)
      end
      print("wrapper created: " .. tostring(name) .. "()")
    end
  end
  pop.window = pop.create("element"):setSize(graphics.getWidth(), graphics.getHeight())
  return print("created window")
end
pop.create = function(elementType, parent, ...)
  if parent == nil then
    parent = pop.window
  end
  local newElement = pop.elements[elementType](parent, ...)
  insert(parent.child, newElement)
  return newElement
end
pop.update = function(dt, element)
  if element == nil then
    element = pop.window
  end
  if not element.excludeUpdating then
    if element.update then
      element:update(dt)
    end
    for i = 1, #element.child do
      pop.update(dt, element.child[i])
    end
  end
end
pop.draw = function(element)
  if element == nil then
    element = pop.window
  end
  if not element.excludeRendering then
    if element.draw then
      local _
      do
        local _base_0 = element
        local _fn_0 = _base_0.draw
        _ = function(...)
          return _fn_0(_base_0, ...)
        end
      end
    end
    for i = 1, #element.child do
      pop.draw(element.child)
    end
  end
end
pop.mousepressed = function(button, x, y, element)
  if element == nil then
    element = pop.window
  end
  if (x >= element.x) and (x <= (element.x + element.w)) then
    if (y >= element.y) and (y <= (element.y + element.h)) then
      for i = 1, #element.child do
        if pop.mousepressed(button, x, y, element.child[i]) then
          return true
        end
      end
      if element.mousepressed then
        return element:mousepressed(button, x - element.x, y - element.y)
      else
        return false
      end
    end
  end
end
pop.mousereleased = function(button, x, y, element)
  if element == nil then
    element = pop.window
  end
end
pop.keypressed = function(key)
  return print("pop.keypressed() is unimplemented.")
end
pop.keyreleased = function(key)
  return print("pop.keyreleased() is unimplemented.")
end
pop.textinput = function(text)
  return print("pop.textinput() is unimplemented.")
end
pop.skin = function(element, skin, apply_to_children)
  if apply_to_children == nil then
    apply_to_children = true
  end
  element.margin = skin.margin
  if element.background then
    element.background = skin.background
  end
  if element.color then
    element.color = skin.color
  end
  if element.font then
    element.font = skin.font
  end
  if apply_to_children then
    for i = 1, #element.child do
      pop.skin(element.child[i], skin)
    end
  end
end
pop.debugDraw = function(element)
  if element == nil then
    element = pop.window
  end
  if element.debugDraw then
    element:debugDraw()
  else
    graphics.setLineWidth(1)
    graphics.setColor(0, 0, 0, 100)
    graphics.rectangle("fill", element.x, element.y, element.w, element.h)
    graphics.setColor(150, 150, 150, 150)
    graphics.rectangle("line", element.x, element.y, element.w, element.h)
    graphics.setColor(200, 200, 200, 255)
    graphics.print(".", element.x, element.y)
  end
  for i = 1, #element.child do
    pop.debugDraw(element.child[i])
  end
end
pop.load()
return pop
