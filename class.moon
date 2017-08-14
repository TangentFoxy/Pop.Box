--- @todo document this!
Class = (name, parent) ->
  local newClass, base
  base = {
    __index: base
    __class: newClass
  }

  newClass = setmetable {
    __init: ->
    __base: base
    __name: name
  }, {
    __call: (cls, ...) ->
      @ = setmetable({}, base)
      cls.__init(@, ...)
      return @
  }

  if parent
    setmetable base, {
      __parent: parent.__base
    }

    newClass.__parent = parent
    newClass.__index = (cls, name) ->
      val = rawget(base, name)
      if val == nil
        return parent[name]
      else
        return val

    if parent.__inherited
      parent\__inherited newClass

  return newClass, base

return Class
