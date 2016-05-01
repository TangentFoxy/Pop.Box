import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/box"
element = require "#{path}/element"

class text extends element
    -- this should be completely unneccessary, but I'm keeping it just in case (and moreso to remember how to do this)
    @wrap = (pop) ->
        return (parent, ...) ->
            if type(parent) == "string"
                return pop.create("text", nil, parent, ...)
            else
                return pop.create("text", parent, ...)

    new: (parent, text="", color={255,255,255,255}) =>
        super parent

        @data.font = graphics.newFont 14
        @setText text
        @data.color = color

    draw: =>
        graphics.setColor @data.color
        graphics.setFont @data.font
        graphics.print @data.text, @data.x, @data.y

        return @

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 200, 0, 0, 200
        graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 255, 200, 200, 255
        graphics.print "t", @data.x, @data.y

        return @

    -- unlike most elements, you cannot set a size for text elements
    setSize: =>
        w = @data.font\getWidth @data.text
        h = @data.font\getHeight! * (select(2, @data.text\gsub("\n", "\n")) + 1) --hack to get height of multiple lines

        switch @data.horizontal
            when "center"
                @data.x -= (w - @data.w)/2
            when "right"
                @data.x -= w - @data.w - @data.margin

        switch @vertical
            when "center"
                @data.y -= (h - @data.h)/2
            when "bottom"
                @data.y -= h - @data.h - @data.margin

        @data.w = w
        @data.h = h

        return @

    -- cannot set width!
    setWidth: =>
        @setSize!
        return @

    -- cannot set height!
    setHeight: =>
        @setSize!
        return @

    setText: (text="") =>
        @data.text = text
        @setSize!
        return @

    getText: =>
        return @data.text

    setFont: (font) =>
        @data.font = font
        @setSize!
        return @

    getFont: =>
        return @data.font

    setColor: (r, g, b, a=255) =>
        if type(r) == "table"
            @data.color = r
        else
            @data.color = {r, g, b, a}

        return @

    getColor: =>
        return unpack @data.color
