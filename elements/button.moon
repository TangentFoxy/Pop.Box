import graphics from love

element = require "#{(...)\sub 1, -7}/element"

class button extends element
    new: (@parent, @data={}) =>
        super @parent, @data

        @data.type = "button" if @data.type == "element"
