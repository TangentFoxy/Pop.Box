--- A generic element every element must inherit from.
--- @classmod element
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

class element
    --- Constructor expects nothing, or a data table describing it.
    --- @tparam ?Element|false parent The parent element.
    --- @tparam table data[opt] The data (state) for this element.
    --- @treturn element self
    new: (@parent, @data={}) =>
        if type @data != "table"
            @data = {}

        @data.parent = false unless @data.parent --included for correctness
        @data.child = {} unless @data.child
        @data.x = 0 unless @data.x
        @data.y = 0 unless @data.y
        @data.w = 0 unless @data.w
        @data.h = 0 unless @data.h
        @data.update = false if @data.update == nil
        @data.draw = true if @data.draw == nil

    --- Sets an element's width/height.
    --- @tparam integer w[opt] Width.
    --- @tparam integer h[opt] Height.
    --- @treturn element self
    setSize: (w, h) =>
        if w
            @data.w = w
        if h
            @data.h = h

        return @

    --- Returns an element's width and height.
    --- @treturn integer Width.
    --- @treturn integer Height.
    getSize: =>
        return @data.w, @data.h

    --- Sets an element's width.
    --- @tparam integer w Width.
    --- @treturn element self
    setWidth: (w) =>
        @data.w = w
        return @

    --- Returns an element's width.
    --- @treturn integer Width.
    getWidth: =>
        return @data.w

    --- Sets an element's height.
    --- @tparam integer h Height.
    --- @treturn element self
    setHeight: (h) =>
        @data.h = h
        return @

    --- Returns an element's height.
    --- @treturn integer Height.
    getHeight: =>
        return @data.h
