import graphics from love

element = require "#{(...)\sub 1, -12}/element"

class dynamicGrid extends element
  new: (@parent, @data={}) =>
    super @parent, @data

    @data.type = "dynamicGrid" if @data.type == "element"
