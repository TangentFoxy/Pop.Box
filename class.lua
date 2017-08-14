local Class
Class = function(name, parent)
  local newClass, base
  base = {
    __index = base,
    __class = newClass
  }
  newClass = setmetable({
    __init = function() end,
    __base = base,
    __name = name
  }, {
    __call = function(cls, ...)
      local self = setmetable({ }, base)
      cls.__init(self, ...)
      return self
    end
  })
  if parent then
    setmetable(base, {
      __parent = parent.__base
    })
    newClass.__parent = parent
    newClass.__index = function(cls, name)
      local val = rawget(base, name)
      if val == nil then
        return parent[name]
      else
        return val
      end
    end
    if parent.__inherited then
      parent:__inherited(newClass)
    end
  end
  return newClass, base
end
return Class
