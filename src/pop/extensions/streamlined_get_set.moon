-- adds methods to elements using a single function for get and set operations
-- ex: instead of getWidth() and setWidth(val), use width() and width(val)

import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/extensions/streamlined_get_set"
element = require "#{path}/elements/element"

element.__base.position = (x, y) =>
    if x or y
        return @setPosition x, y
    else
        return @getPosition!
