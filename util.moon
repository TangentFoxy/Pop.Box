--- Utility functions, intended for internal use only.
--- @module util
--- @copyright Paul Liverman III (2015-2016)
--- @license The MIT License (MIT)
--- @release 0.0.0

--- @function inheritsFromElement
--- @param object A table (MoonScript object expected) to be checked for inheritence from the "element" element.
--- @return `true` / `false`: Is the table an object inherting from "element"?
--- @raise Can error if the table has a similar structure to a MoonScript object without being the same structure.
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
