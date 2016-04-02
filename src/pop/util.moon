inheritsFromElement = (object) ->
    if object and object.__class
        cls = object.__class

        if cls.__name == "element"
            return true

        while cls.__parent
            cls = cls.__parent
            if cls.__name == "element"
                return true

    return false

return {
    :inheritsFromElement
}
