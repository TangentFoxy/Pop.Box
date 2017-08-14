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
end
return Class
