local pop
local mouse
mouse = love.mouse
local path = (...):sub(1, -7)
local element = require(tostring(path) .. "/element")
local box = require(tostring(path) .. "/box")
local text = require(tostring(path) .. "/text")
local window
do
  local _class_0
  local _parent_0 = element
  local _base_0 = {
    load = function(pop_lib)
      pop = pop_lib
    end,
    align = function(self, ...)
      if not (self.data.align) then
        return self
      end
      _class_0.__parent.__base.align(self, ...)
      self.header:align()
      self.title:align()
      self.window_area:align()
      self.window_area:move(nil, self.header:getHeight())
      return self
    end,
    setSize = function(self, w, h)
      local x = 0
      local y = 0
      if w then
        local _exp_0 = self.data.horizontal
        if "center" == _exp_0 then
          x = x - ((w - self.data.w) / 2)
        elseif "right" == _exp_0 then
          x = x - (w - self.data.w)
        end
        self.header:setWidth(w)
        self.window_area:setWidth(w)
        self.data.w = w
        self.data.x = self.data.x + x
        self.title:align()
      end
      if h then
        local _exp_0 = self.data.vertical
        if "center" == _exp_0 then
          y = y - ((h - self.data.h) / 2)
        elseif "right" == _exp_0 then
          y = y - (h - self.data.h)
        end
        self.window_area:setHeight(h - self.header:getHeight())
        self.window_area:move(nil, self.header:getHeight())
        self.data.h = h
        self.data.y = self.data.y + y
      end
      self.header:move(x, y)
      self.window_area:move(x, y)
      return self
    end,
    setWidth = function(self, w)
      return self:setSize(w)
    end,
    setHeight = function(self, h)
      return self:setSize(nil, h)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, data, title)
      if data == nil then
        data = { }
      end
      if title == nil then
        title = "Window"
      end
      self.parent, self.data = parent, data
      _class_0.__parent.__init(self, self.parent, self.data)
      self.data.type = "window"
      if not (self.data.w > 0) then
        self.data.w = 100
      end
      if not (self.data.h > 0) then
        self.data.h = 80
      end
      if not (self.data.containMethod) then
        self.data.containMethod = "mouse"
      end
      self.header = pop.box(self, self.data.titleBackground or {
        25,
        180,
        230,
        255
      })
      self.title = pop.text(self.header, {
        horizontal = "center"
      }, title, self.data.titleColor or {
        255,
        255,
        255,
        255
      })
      self.window_area = pop.box(self, self.data.windowBackground or {
        200,
        200,
        210,
        255
      })
      local height = self.title:getHeight()
      self.header:setSize(self.data.w, height)
      self.window_area:setSize(self.data.w, self.data.h - height)
      self.window_area:move(nil, height)
      self.window_area.mousepressed = function(x, y, button)
        if button == pop.constants.left_mouse then
          local grandparent = self.parent.parent
          table.insert(grandparent.child, table.remove(grandparent.child, grandparent:indexOf(self.parent)))
        end
        return nil
      end
      self.window_area.clicked = function()
        return nil
      end
      local selected = false
      local mx = 0
      local my = 0
      self.header.mousemoved = function(self, x, y, dx, dy)
        if selected then
          self.parent:move(dx, dy)
          local grandparent = self.parent.parent
          local _exp_0 = self.parent.data.containMethod
          if "title" == _exp_0 then
            if self.data.x < grandparent.data.x then
              self.parent:move(grandparent.data.x - self.data.x)
            end
            if self.data.y < grandparent.data.y then
              self.parent:move(nil, grandparent.data.y - self.data.y)
            end
            if self.data.x + self.data.w > grandparent.data.x + grandparent.data.w then
              self.parent:move(grandparent.data.x + grandparent.data.w - (self.data.x + self.data.w))
            end
            if self.data.y + self.data.h > grandparent.data.y + grandparent.data.h then
              self.parent:move(nil, grandparent.data.y + grandparent.data.h - (self.data.y + self.data.h))
            end
          elseif "body" == _exp_0 then
            if self.data.x < grandparent.data.x then
              self.parent:move(grandparent.data.x - self.data.x)
            end
            if self.data.y < grandparent.data.y then
              self.parent:move(nil, grandparent.data.y - self.data.y)
            end
            if self.parent.data.x + self.parent.data.w > grandparent.data.x + grandparent.data.w then
              self.parent:move(grandparent.data.x + grandparent.data.w - (self.parent.data.x + self.parent.data.w))
            end
            if self.parent.data.y + self.parent.data.h > grandparent.data.y + grandparent.data.h then
              self.parent:move(nil, grandparent.data.y + grandparent.data.h - (self.parent.data.y + self.parent.data.h))
            end
          elseif "mouse" == _exp_0 then
            if mouse.getX() < grandparent.data.x then
              self.parent:setPosition(grandparent.data.x + self.data.w - mx)
            end
            if mouse.getY() < grandparent.data.y then
              self.parent:setPosition(nil, grandparent.data.y + self.parent.data.h - my)
            end
            if mouse.getX() > grandparent.data.x + grandparent.data.w then
              self.parent:setPosition(grandparent.data.x + grandparent.data.w + self.data.w - mx)
            end
            if mouse.getY() > grandparent.data.y + grandparent.data.h then
              self.parent:setPosition(nil, grandparent.data.y + grandparent.data.h + self.parent.data.h - my)
            end
          end
          return true
        end
        return false
      end
      self.header.mousepressed = function(self, x, y, button)
        if button == pop.constants.left_mouse then
          local grandparent = self.parent.parent
          table.insert(grandparent.child, table.remove(grandparent.child, grandparent:indexOf(self.parent)))
          selected = true
          mx = x
          my = y
          return true
        end
        return false
      end
      self.header.mousereleased = function(self, x, y, button)
        if button == pop.constants.left_mouse then
          selected = false
          return true
        end
        return false
      end
      return self:align()
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
