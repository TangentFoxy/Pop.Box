import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/box"
element = require "#{path}/element"

--util = sub path, 1, len(path) - len "/elements"
--import inheritsFromElement from require "#{util}/util"

class text extends element
    wrap: (pop) ->
        return (parent, ...) ->
            if type(parent) == "string"
                return pop.create("text", nil, parent, ...)
            else--if inheritsFromElement parent
                return pop.create("text", parent, ...)
            --elseif parent == false
            --    return pop.create("text", )
            --    error "text wrapper failed", parent

    new: (parent, text="", color={255,255,255,255}) =>
        super parent

        @font = graphics.newFont 14
        @setText text
        @color = color

    draw: =>
        graphics.setColor @color
        graphics.setFont @font
        graphics.print @text, @x, @y

        return @

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 200, 0, 0, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 255, 200, 200, 255
        graphics.print "t", @x, @y

        return @

    -- unlike most elements, you cannot set a size for text elements
    setSize: =>
        w = @font\getWidth @text
        h = @font\getHeight! * (select(2, @text\gsub("\n", "\n")) + 1) --hack to get height of multiple lines

        switch @horizontal
            when "center"
                @x -= (w - @w)/2
            when "right"
                @x -= w - @w - @margin

        switch @vertical
            when "center"
                @y -= (h - @h)/2
            when "bottom"
                @y -= h - @h - @margin

        @w = w
        @h = h

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
        @text = text
        @setSize!
        return @

    getText: =>
        return @text

    setFont: (font) =>
        @font = font
        @setSize!
        return @

    getFont: =>
        return @font

    setColor: (r, g, b, a=255) =>
        if type(r) == "table"
            @color = r
        else
            @color = {r, g, b, a}

        return @

    getColor: =>
        return unpack @color
