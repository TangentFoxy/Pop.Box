-- basically, gonna use the knowledge of how MoonScript classes work to make
--  something that does the same thing using syntax similar to MiddleClass

Class = (name) ->
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

  return newClass

return Class

-- base obj with an __index to itself, contains functions accepting a self argument,
--  and __class pointing to class obj
--
-- class is obj w __init function, __base linking to base obj, and __name specifying name of class
--  it has metatable, __index is the base table (makes perfect sense),
--   __call is a function that creates a self obj w the base obj as a metatable, then calls __init
--      on it, and returns the self (__init is never meant to get directly called)
--
-- inheritance addtionally does:
--
-- new base obj will have a metatable set to parent.__base (where parent is parent class obj)
-- new class obj will have __parent value linking to parent class obj, and __index metamethod
--   that returns rawget(new base, name) or return parent class[name] if that was nil
-- if parent class had __inherited, then is called w parent class and new class
