local filesystem, graphics
do
  local _obj_0 = love
  filesystem, graphics = _obj_0.filesystem, _obj_0.graphics
end
local insert
insert = table.insert
local path = ...
local Pop
do
  local _class_0
  local _base_0 = {
    create = function(self, elementType, parent, ...)
      if parent == nil then
        parent = self.window
      end
      local newElement = self.elements[elementType](parent, ...)
      insert(parent.child, newElement)
      return newElement
    end,
    update = function(self, dt, element)
      if element == nil then
        element = self.window
      end
      if not element.excludeUpdating then
        if element.update then
          element:update(dt)
        end
        for i = 1, #element.child do
          self:update(dt, element.child[i])
        end
      end
    end,
    draw = function(self, element)
      if element == nil then
        element = self.window
      end
      if not element.excludeRendering then
        if element.draw then
          local _
          do
            local _base_1 = element
            local _fn_0 = _base_1.draw
            _ = function(...)
              return _fn_0(_base_1, ...)
            end
          end
        end
        for i = 1, #element.child do
          self:draw(element.child[i])
        end
      end
    end,
    mousepressed = function(self, button, x, y, element)
      if element == nil then
        element = self.window
      end
      if (x >= element.x) and (x <= (element.x + element.w)) then
        if (y >= element.y) and (y <= (element.y + element.h)) then
          for i = 1, #element.child do
            if self:mousepressed(button, x, y, element.child[i]) then
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
    end,
    mousereleased = function(self, button, x, y, element)
      if element == nil then
        element = self.window
      end
      if (x >= element.x) and (x <= (element.x + element.w)) then
        if (y >= element.y) and (y <= (element.y + element.h)) then
          for i = 1, #element.child do
            if self:mousereleased(button, x, y, element.child[i]) then
              return true
            end
          end
          if element.mousereleased then
            return element:mousereleased(button, x - element.x, y - element.y)
          else
            return false
          end
        end
      end
    end,
    keypressed = function(self, key)
      return error("Unimplemented.")
    end,
    keyreleased = function(self, key)
      return error("Unimplemented.")
    end,
    textinput = function(self, text)
      return error("Unimplemented.")
    end,
    skin = function(self, element, skin, apply_to_children)
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
          self:skin(element.child[i], skin)
        end
      end
    end,
    debugDraw = function(self, element)
      if element == nil then
        element = self.window
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
        self:debugDraw(element.child[i])
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.elements = { }
      self.window = {
        child = { }
      }
      local elements = filesystem.getDirectoryItems(tostring(path) .. "/elements")
      for i = 1, #elements do
        local name = elements[i]:sub(1, -5)
        self.elements[name] = require(tostring(path) .. "/elements/" .. tostring(name))
        print("loaded element: " .. tostring(name))
        if not self[name] then
          self[name] = function(self, ...)
            return self:create(name, ...)
          end
          print("wrapper created: " .. tostring(name) .. "()")
        end
      end
      self.window = self:create("element", self.window):setSize(graphics.getWidth(), graphics.getHeight())
      return print("created window")
    end,
    __base = _base_0,
    __name = "Pop"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Pop = _class_0
  return _class_0
end
