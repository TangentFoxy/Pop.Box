import graphics from love

element = require "#{(...)\sub 1, -10}/element"

class scrollbox extends element
    new: (@parent, @data={}) =>
        super @parent, @data

        @data.type = "scrollbox" if @data.type == "element"
