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
pop.skins = { }
pop.screen = false
pop.focused = false
pop.load = function()
  local elements = filesystem.getDirectoryItems(tostring(path) .. "/elements")
  for i = 1, #elements do
    local _continue_0 = false
    repeat
      if not (elements[i]:sub(-4) == ".lua") then
        _continue_0 = true
        break
      end
      local name = elements[i]:sub(1, -5)
      pop.elements[name] = require(tostring(path) .. "/elements/" .. tostring(name))
      print("element loaded: \"" .. tostring(name) .. "\"")
      if not (pop[name]) then
        if pop.elements[name].wrap then
          pop[name] = pop.elements[name].wrap(pop)
        else
          pop[name] = function(...)
            return pop.create(name, ...)
          end
        end
        print("wrapper created: \"pop." .. tostring(name) .. "()\"")
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  local skins = filesystem.getDirectoryItems(tostring(path) .. "/skins")
  for i = 1, #skins do
    local _continue_0 = false
    repeat
      if not (skins[i]:sub(-4) == ".lua") then
        _continue_0 = true
        break
      end
      local name = skins[i]:sub(1, -5)
      pop.skins[name] = require(tostring(path) .. "/skins/" .. tostring(name))
      print("skin loaded: \"" .. tostring(name) .. "\"")
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  pop.screen = pop.create("element", false):setSize(graphics.getWidth(), graphics.getHeight())
  return print("created \"pop.screen\"")
end
pop.create = function(element, parent, ...)
  if parent == nil then
    parent = pop.screen
  end
  if parent then
    print(parent.__class, parent.__class.__name, parent.__class.__base, parent.__class.__parent)
  end
  element = pop.elements[element](parent, ...)
  if parent then
    insert(parent.child, element)
  end
  return element
end
pop.update = function(dt, element)
  if element == nil then
    element = pop.screen
  end
  if not (element.excludeUpdate) then
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
    element = pop.screen
  end
  if not (element.excludeDraw) then
    if element.draw then
      element:draw()
    end
    for i = 1, #element.child do
      pop.draw(element.child[i])
    end
  end
end
pop.mousepressed = function(x, y, button, element)
  if element == nil then
    element = pop.screen
  end
  if element == pop.screen then
    print("mousepressed", x, y, button, element)
  end
  local handled = false
  if (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h) then
    if element.mousepressed then
      handled = element:mousepressed(x - element.x, y - element.y, button)
    end
    if handled then
      pop.focused = element
    else
      for i = 1, #element.child do
        handled = pop.mousepressed(x, y, button, element.child[i])
        if handled then
          pop.focused = element.child[i]
          break
        end
      end
    end
  end
  return handled
end
pop.mousereleased = function(x, y, button, element)
  if element == nil then
    element = pop.screen
  end
  return false
end
pop.keypressed = function(key)
  print("keypressed", key)
  return false
end
pop.keyreleased = function(key)
  print("keyreleased", key)
  return false
end
pop.textinput = function(text)
  print("textinput", text)
  return false
end
pop.skin = function(element, skin, depth)
  if element == nil then
    element = pop.screen
  end
  if skin == nil then
    skin = pop.skins.default
  end
  if element.background and skin.background then
    element.background = skin.background
  end
  if element.color and skin.color then
    element.color = skin.color
  end
  if element.font and skin.font then
    element.font = skin.font
  end
  if not (depth or (depth == 0)) then
    if depth == tonumber(depth) then
      for i = 1, #element.child do
        pop.skin(element.child[i], skin, depth - 1)
      end
    else
      for i = 1, #element.child do
        pop.skin(element.child[i], skin, false)
      end
    end
  end
end
pop.debugDraw = function(element)
  if element == nil then
    element = pop.screen
  end
  if element.debugDraw then
    element:debugDraw()
  else
    graphics.setLineWidth(1)
    graphics.setLineColor(0, 0, 0, 100)
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
