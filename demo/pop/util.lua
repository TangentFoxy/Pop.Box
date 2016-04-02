local inheritsFromElement
inheritsFromElement = function(object)
  if object and object.__class then
    local cls = object.__class
    if cls.__name == "element" then
      return true
    end
    while cls.__parent do
      cls = cls.__parent
      if cls.__name == "element" then
        return true
      end
    end
  end
  return false
end
return {
  inheritsFromElement = inheritsFromElement
}
