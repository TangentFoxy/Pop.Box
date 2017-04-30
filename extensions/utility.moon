--- @todo doc me
--- Functions I am not certain should be part of base classes, but nevertheless
--- may be useful.

import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/extensions/streamlined_get_set"
element = require "#{path}/elements/element"
--box = require "#{path}/elements/box"
--text = require "#{path}/elements/text"

element.__base.fill = =>
  @data.x = @parent.data.x + @data.padding
  @data.y = @parent.data.y + @data.padding
  @data.w = @parent.data.w - @data.padding*2
  @data.h = @parent.data.h - @data.padding*2
