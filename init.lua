local pop = {
  _VERSION = '0.0.0',
  _DESCRIPTION = 'GUI library for LOVE, designed for ease of use',
  _URL = 'http://github.com/Guard13007/Pop.Box',
  _LICENSE = 'The MIT License (MIT)',
  _AUTHOR = 'Paul Liverman III'
}
local log
log = function(...)
  return print("[Pop.Box]", ...)
end
if not (love.getVersion) then
  error("Pop.Box only supports LOVE versions >= 0.9.1")
end
local path = (...):gsub("%.", "/")
if (...):sub(-4) == "init" then
  path = (...):sub(1, -5)
  if not (path) then
    path = "."
  end
end
log("Require path detected: \"" .. tostring(path) .. "\"")
local filesystem, graphics
do
  local _obj_0 = love
  filesystem, graphics = _obj_0.filesystem, _obj_0.graphics
end
local insert
insert = table.insert
local inheritsFromElement
inheritsFromElement = require(tostring(path) .. "/util").inheritsFromElement
local dumps, loads
do
  local _obj_0 = require(tostring(path) .. "/lib/bitser/bitser")
  dumps, loads = _obj_0.dumps, _obj_0.loads
end
pop.elements = { }
pop.skins = { }
pop.extensions = { }
pop.screen = false
pop.focused = false
pop.log = log
pop.load = function()
  log("Loading elements from \"" .. tostring(path) .. "/elements\"")
  local elements = filesystem.getDirectoryItems(tostring(path) .. "/elements")
  for i = 1, #elements do
    local _continue_0 = false
    repeat
      if not (elements[i]:sub(-4) == ".lua") then
        log("Ignored non-Lua file \"" .. tostring(path) .. "/elements/" .. tostring(elements[i]) .. "\"")
        _continue_0 = true
        break
      end
      local name = elements[i]:sub(1, -5)
      log("Requiring \"" .. tostring(name) .. "\" from \"" .. tostring(path) .. "/elements/" .. tostring(name) .. "\"")
      pop.elements[name] = require(tostring(path) .. "/elements/" .. tostring(name))
      if pop.elements[name].load then
        pop.elements[name].load(pop)
      end
      log("Element loaded: \"" .. tostring(name) .. "\"")
      if not (pop[name]) then
        if pop.elements[name].wrap then
          pop[name] = pop.elements[name].wrap(pop)
        else
          pop[name] = function(...)
            return pop.create(name, ...)
          end
        end
        log("Wrapper created: \"pop." .. tostring(name) .. "()\"")
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
        log("Ignored non-Lua file \"" .. tostring(path) .. "/skins/" .. tostring(skins[i]) .. "\"")
        _continue_0 = true
        break
      end
      local name = skins[i]:sub(1, -5)
      log("Requiring \"" .. tostring(name) .. "\" from \"" .. tostring(path) .. "/skins/" .. tostring(name) .. "\"")
      pop.skins[name] = require(tostring(path) .. "/skins/" .. tostring(name))
      if pop.skins[name].load then
        pop.skins[name].load(pop)
      end
      log("Skin loaded: \"" .. tostring(name) .. "\"")
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  local extensions = filesystem.getDirectoryItems(tostring(path) .. "/extensions")
  for i = 1, #extensions do
    local _continue_0 = false
    repeat
      if not (extensions[i]:sub(-4) == ".lua") then
        log("Ignored non-Lua file \"" .. tostring(path) .. "/extensions/" .. tostring(extensions[i]) .. "\"")
        _continue_0 = true
        break
      end
      local name = extensions[i]:sub(1, -5)
      log("Requiring \"" .. tostring(name) .. "\" from \"" .. tostring(path) .. "/extensions/" .. tostring(name) .. "\"")
      pop.extensions[name] = require(tostring(path) .. "/extensions/" .. tostring(name))
      if pop.extensions[name].load then
        pop.extensions[name].load(pop)
      end
      log("Extension loaded: \"" .. tostring(name) .. "\"")
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  pop.screen = pop.create("element", false):setSize(graphics.getWidth(), graphics.getHeight())
  return log("Created \"pop.screen\"")
end
pop.create = function(element, parent, data, ...)
  if parent == nil then
    parent = pop.screen
  end
  if inheritsFromElement(parent) then
    if type(data) == "table" then
      element = pop.elements[element](parent, data, ...)
    else
      element = pop.elements[element](parent, { }, data, ...)
    end
    insert(parent.child, element)
    insert(parent.data.child, element.data)
    element.data.parent = parent.data
  elseif parent == false then
    if type(data) == "table" then
      element = pop.elements[element](false, data, ...)
    else
      element = pop.elements[element](false, { }, data, ...)
    end
    element.parent = false
    element.data.parent = false
  else
    if type(parent) == "table" then
      element = pop.elements[element](pop.screen, parent, data, ...)
    else
      element = pop.elements[element](pop.screen, { }, parent, data, ...)
    end
    insert(pop.screen.child, element)
    insert(pop.screen.data.child, element.data)
    element.data.parent = pop.screen.data
  end
  return element
end
pop.update = function(dt, element)
  if element == nil then
    element = pop.screen
  end
  if element.data.update then
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
  if element.data.draw then
    if element.draw then
      element:draw()
    end
    for i = 1, #element.child do
      pop.draw(element.child[i])
    end
  end
end
pop.mousemoved = function(x, y, dx, dy)
  if pop.focused and pop.focused.mousemoved then
    return pop.focused:mousemoved(x - pop.focused.data.x, y - pop.focused.data.y, dx, dy)
  end
  return false
end
pop.mousepressed = function(x, y, button, element)
  if not (element) then
    log("mousepressed", x, y, button)
    element = pop.screen
  end
  local handled = false
  if (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h) then
    for i = #element.child, 1, -1 do
      do
        handled = pop.mousepressed(x, y, button, element.child[i])
        if handled then
          return handled
        end
      end
    end
    if not (handled) then
      if element.mousepressed and element.data.draw then
        do
          handled = element:mousepressed(x - element.data.x, y - element.data.y, button)
          if handled then
            pop.focused = element
          end
        end
      end
    end
  end
  return handled
end
pop.mousereleased = function(x, y, button, element)
  local clickedHandled = false
  local mousereleasedHandled = false
  if element then
    if (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h) then
      for i = #element.child, 1, -1 do
        clickedHandled, mousereleasedHandled = pop.mousereleased(x, y, button, element.child[i])
        if clickedHandled or mousereleasedHandled then
          return clickedHandled, mousereleasedHandled
        end
      end
      if not (clickedHandled or mousereleasedHandled) then
        if element.clicked and element.data.draw then
          clickedHandled = element:clicked(x - element.data.x, y - element.data.y, button)
        end
        if element.mousereleased then
          mousereleasedHandled = element:mousereleased(x - element.data.x, y - element.data.y, button)
        end
        if clickedHandled then
          pop.focused = element
        end
      end
    end
  else
    log("mousereleased", x, y, button)
    pop.mousereleased(x, y, button, pop.screen)
  end
  return clickedHandled, mousereleasedHandled
end
pop.keypressed = function(key)
  log("keypressed", key)
  local element = pop.focused
  if element and element.keypressed and element.data.draw then
    return element.keypressed(key)
  end
  return false
end
pop.keyreleased = function(key)
  log("keyreleased", key)
  local element = pop.focused
  if element and element.keyreleased then
    return element.keyreleased(key)
  end
  return false
end
pop.textinput = function(text)
  log("textinput", text)
  local element = pop.focused
  if element and element.textinput and element.data.draw then
    return element.textinput(text)
  end
  return false
end
pop.import = function(data, parent)
  if parent == nil then
    parent = pop.screen
  end
  local element
  if type(data) == "string" then
    data = loads(data)
    element = pop.create(data.type, parent, data)
  else
    element = pop.elements[data.type](parent, data)
    insert(parent.child, element)
  end
  for i = 1, #data.child do
    pop.import(data.child[i], element)
  end
end
pop.export = function(element)
  if element == nil then
    element = pop.screen
  end
  return dumps(element.data)
end
pop.debugDraw = function(element)
  if element == nil then
    element = pop.screen
  end
  if element.debugDraw then
    element:debugDraw()
  else
    graphics.setLineWidth(1)
    graphics.setColor(0, 0, 0, 100)
    graphics.rectangle("fill", element.data.x, element.data.y, element.data.w, element.data.h)
    graphics.setColor(150, 150, 150, 150)
    graphics.rectangle("line", element.data.x, element.data.y, element.data.w, element.data.h)
    graphics.setColor(200, 200, 200, 255)
    graphics.print(".", element.data.x, element.data.y)
  end
  for i = 1, #element.child do
    pop.debugDraw(element.child[i])
  end
end
pop.printElementTree = function(element, depth)
  if element == nil then
    element = pop.screen
  end
  if depth == nil then
    depth = 0
  end
  local cls = element.__class.__name
  if cls == "text" then
    cls = cls .. " (\"" .. tostring(element:getText():gsub("\n", "\\n")) .. "\")"
  elseif cls == "box" then
    local bg = element:getBackground()
    if type(bg) == "table" then
      bg = tostring(bg[1]) .. ", " .. tostring(bg[2]) .. ", " .. tostring(bg[3]) .. ", " .. tostring(bg[4])
    end
    cls = cls .. " (" .. tostring(bg) .. ")"
  end
  log(string.rep("-", depth) .. " " .. tostring(cls))
  for i = 1, #element.child do
    pop.printElementTree(element.child[i], depth + 1)
  end
end
pop.load()
return pop
