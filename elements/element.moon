--- A generic element every element must inherit from.
--- @classmod element
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

class element
    --- Constructor expects nothing, or a data table describing it.
    new: (@parent, @data={}) =>
        --- @todo if data, do stuff about it

    setSize: =>
        --do more stuff!
