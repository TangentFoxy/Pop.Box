--- A generic window element. Supports resizing, minimizing(?), and closing.
--- @classmod window
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

class window
    --- Constructor expects nothing, or a data table describing it.
    new: (@parent, @data={}) =>
        --- @todo if data, do stuff about it

    setSize: =>
        --do more stuff!
