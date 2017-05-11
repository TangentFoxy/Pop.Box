import graphics from love

element = require "#{(...)\sub 1, -5}/element"

class grid extends element
    new: (@parent, @data={}) =>
        super @parent, @data

        @data.type = "grid" if @data.type == "element"
