import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/text"
element = require "#{path}/element"

class text extends element
    new: (pop, parent, text="", color={255,255,255,255}) =>
        super pop, parent

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

    setSize: =>
        w = @font\getWidth @text
        h = @font\getHeight! * (select(2, @text\gsub("\n", "\n")) + 1) --hack to get height of multiple lines of text

        switch @horizontal
            when "center"
                @x -= (w - @w)/2
            when "right"
                @x -= w - @w - @margin

        switch @vertical
            when "center"
                @y -= (h - @h)/2
            when "right"
                @y -= h - @h - @margin

        @w = w
        @h = h

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
        @color = {r, g, b, a}
        return @

    getColor: =>
        return unpack @color
