import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/box"
element = require "#{path}/element"

class box extends element
    new: (parent, background=false) =>
        --TODO clean this up (duplicated code is buggy and annoying!)

        -- if table, check that it is exactly only 3 or 4 numeric values, anything else is data
        if type(background) == "table"
            for k,v in pairs background
                if type(k) != "number"
                    super parent, background -- background is actually a data table!
                    if not background.w
                        @data.w = 20
                    if not background.h
                        @data.h = 20
                    if not @data.background
                        @data.background = false
                    return
            --if #background < 3 or #background > 4
            --    super parent, background     -- background has too many or too few values to be a color...though this makes NO SENSE
            --    -- would need to do the same things as above here, but it makes no sense to have this, even though it is possible, it MUST be user error

        super parent
        if not background.w
            @data.w = 20
        if not background.h
            @data.h = 20
        if not @data.background
            @data.background = background -- we can only assume it is userdata (some LOVE object) or a color table (or the false default)

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
