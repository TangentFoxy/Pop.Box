import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/box"
element = require "#{path}/element"

class box extends element
    new: (parent, background=false) =>
        super parent

        @data.w = 20
        @data.h = 20

        @data.background = background

    draw: =>
        if @data.background
            if type(@data.background) == "table"
                graphics.setColor @data.background
                graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
            else
                w, h = @data.background\getDimensions!
                w = @data.w / w
                h = @data.h / h
                graphics.setColor 255, 255, 255, 255
                graphics.draw @data.background, @data.x, @data.y, 0, w, h

        return @

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 0, 0, 200, 200
        graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 200, 200, 255, 255
        graphics.print "b", @data.x, @data.y

        return @

    setBackground: (background) =>
        @data.background = background
        return @

    getBackground: =>
        return @data.background

    setColor: (r, g, b, a=255) =>
        if type(r) == "table"
            @data.background = r
        else
            @data.background = {r, g, b, a}

        return @

    getColor: =>
        if type(@data.background) == "table"
            return unpack @data.background
        else
            error "Box \"#{@}\" doesn't have a color." --might be a bad idea
