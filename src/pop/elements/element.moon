import graphics from love
import floor from math

class element
    new: (parent) =>
        @parent = parent
        @child = {}

        if parent
            @x = parent.x or 0
            @y = parent.y or 0
        else
            @x = 0
            @y = 0

        @w = 20
        @h = 20

        @horizontal = "left"
        @vertical = "top"
        @margin = 0

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 0, 200, 0, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 200, 255, 200, 255
        graphics.print "e", @x, @y

        return @

    move: (x, y) =>
        if x
            @x = @x + x
        if y
            @y = @y + y

        for i = 1, #@child
            unless @child[i].excludeMovement
                @child[i]\move x, y

        return @

    setPosition: (x, y) =>
        oldX = @x
        oldY = @y

        if x
            switch @horizontal
                when "left"
                    @x = x
                when "center"
                    @x = x - @w/2
                when "right"
                    @x = x - @w
        else
            x = oldX

        if y
            switch @vertical
                when "top"
                    @y = y
                when "center"
                    @y = y - @h/2
                when "bottom"
                    @y = y - @h
        else
            y = oldY

        for i = 1, #@child
            unless @child[i].excludeMovement
                @child[i]\move x - oldX, y - oldY

        return @

    getPosition: =>
        resultX = @x
        resultY = @y

        switch @horizontal
            when "center"
                resultX += @w/2
            when "right"
                resultY += @w

        switch @vertical
            when "center"
                resultY += @h/2
            when "bottom"
                resultY += @h

        return resultX, resultY

    setSize: (w, h) =>
        if w
            switch @horizontal
                when "center"
                    @x -= (w - @w)/2
                when "right"
                    @x -= w - @w

            @w = w

        if h
            switch @vertical
                when "center"
                    @y -= (h - @h)/2
                when "bottom"
                    @y -= h - @h

            @h = h

        return @

    getSize: =>
        return @w, @h

    setWidth: (w) =>
        switch @horizontal
            when "center"
                @x -= (w - @w)/2
            when "right"
                @x -= w - @w

        @w = w

        return @

    getWidth: =>
        return @w

    setHeight: (h) =>
        switch @vertical
            when "center"
                @y -= (h - @h)/2
            when "bottom"
                @y -= h - @h

        @h = h

        return @

    getHeight: =>
        return @h

    adjustSize: (w, h) =>
        W, H = @getSize!

        if w
            W += w
        if h
            H += h

        @setSize W, H

        return @

    --TODO note that align requires a parent!
    align: (horizontal, vertical, toPixel) =>
        @setAlignment horizontal, vertical

        @x = @parent.x
        @y = @parent.y

        switch @horizontal
            when "left"
                @x += @margin
            when "center"
                @x += (@parent.w - @w)/2
            when "right"
                @x += @parent.w - @w - @margin

        switch @vertical
            when "top"
                @y += @margin
            when "center"
                @y += (@parent.h - @h)/2
            when "bottom"
                @y += @parent.h - @h - @margin

        if toPixel or (toPixel == nil)
            @x = floor @x
            @y = floor @y

        return @

    alignTo: (element, horizontal, vertical) =>
        parent = @parent
        @parent = element

        @align horizontal, vertical

        @parent = parent

        return @

    setAlignment: (horizontal, vertical) =>
        if horizontal
            @horizontal = horizontal
        if vertical
            @vertical = vertical

        return @

    setMargin: (margin) =>
        @margin = margin
        @align!
        return @

    getMargin: =>
        return @margin
