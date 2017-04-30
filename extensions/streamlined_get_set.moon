--- @todo doc me (and add me to config.ld)
-- Adds methods to elements using a single function for get and set operations.
-- ex: instead of getWidth() and setWidth(value), width() and width(value)

import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/extensions/streamlined_get_set"
element = require "#{path}/elements/element"
box = require "#{path}/elements/box"
text = require "#{path}/elements/text"

element.__base.position = (x, y) =>
  if x or y
    return @setPosition x, y
  else
    return @getPosition!

element.__base.size = (w, h) =>
  if w or h
    return @setSize w, h
  else
    return @getSize!

element.__base.width = (w) =>
  if w
    return @setWidth w
  else
    return @getWidth!

elements.__base.height = (h) =>
  if h
    return @setHeight h
  else
    return @getHeight!

--- @todo continue copying from old version... (and add new things or whatever)
