--- A generic text element. Very basic.
--- @classmod text
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

import graphics from love

element = require "#{(...)\sub 1, -5}/element"

class text extends element
    --- Constructor expects nothing, or a data table describing it.
    new: (@parent, @data={}, text="", fontFile, fontSize=14) =>
        super @parent, @data

        -- this makes text optional, a number can be passed to set font size immediately
        if "number" == type text
          fontSize = fontFile
          fontFile = text
          text = ""

        @data.type = "text"
        @data.text = text unless @data.text
        @data.fontFile = fontFile unless @data.fontFile
        @data.fontSize = fontSize unless @data.fontSize
        @data.color = {255, 255, 255, 255} unless @data.color

        if "string" == type @data.fontFile
            @font = graphics.newFont(@data.fontFile, @data.fontSize)
        elseif "number" == type @data.fontFile
            @font = graphics.newFont(@data.fontFile)
        else
            @font = graphics.newFont(@data.fontSize)

        @setSize!

    draw: =>
        graphics.setColor(@data.color)
        graphics.setFont(@font)
        graphics.print(@data.text, @data.x, @data.y)

        return @

    --- Size is dependant on the text and font, so you cannot specify a size.
    --- @treturn element self
    setSize: =>
        @data.w = @font\getWidth @data.text
        @data.h = @font\getHeight! * (select(2, @data.text\gsub("\n", "\n")) + 1) --hack to get height of multiple lines
        return @

    --- Returns text.
    --- @treturn string text
    getText: =>
      return @data.text

    --- Text should be set this way, or the object will not be the correct size.
    --- @tparam string text The text to set.
    --- @treturn element self
    setText: (text) =>
        @data.text = tostring text
        @setSize!
        return @align!

    --- Change text color. Uses LOVE's 0-255 values for components of colors.
    --- @tparam ?number|table r The red component or a table of RGBA values.
    --- @tparam number g The green component.
    --- @tparam number b The blue component.
    --- @tparam number a The alpha component. While not technically required, if
    --- ANYTHING uses an alpha component and you don't, it could cause bugs in
    --- rendering.
    --- @treturn element self
    setColor: (r, g, b, a) =>
        if "table" == type r
            @data.color = r
        else
            @data.color = {r, g, b, a}
        return @
