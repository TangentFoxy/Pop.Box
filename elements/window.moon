--- A generic window element. Built-in support for minimize, maximize, and close
--- buttons, as well as drag-to-resize and drag-to-move. Title bar customizable.
--- @classmod window
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

element = require "#{(...)\sub 1, -7}/element"

class window extends element
    --- Constructor expects nothing, or a data table describing it.
    new: (@parent, @data={}) =>
        super @parent, @data

        @data.type = "window"

        --- @todo if data, do stuff about it

    --setSize: =>
        --do more stuff!
