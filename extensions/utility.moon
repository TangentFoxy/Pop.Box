--- @todo doc me
--- Functions I am not certain should be part of base classes, but nevertheless
--- may be useful.

import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/extensions/utility"
element = require "#{path}/elements/element"
--box = require "#{path}/elements/box"
--text = require "#{path}/elements/text"

--- @todo make this built-in as maximize for window elements
--- @todo rewrite to take into account margin!
element.__base.fill = =>
  @data.x = @parent.data.x + @parent.data.padding
  @data.y = @parent.data.y + @parent.data.padding
  @data.w = @parent.data.w - @parent.data.padding*2
  @data.h = @parent.data.h - @parent.data.padding*2
