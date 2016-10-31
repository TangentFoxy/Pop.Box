--- A generic window element. Supports resizing, minimizing(?), and closing.
--- @classmod window
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

element = require "#{(...)\sub 1, -7}/element"

class window extends element
    --- Constructor expects nothing, or a data table describing it.
    new: (@parent, @data={}) =>
        super @parent, @data

        --- @todo if data, do stuff about it

    setSize: =>
        --do more stuff!
