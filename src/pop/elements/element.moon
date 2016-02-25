import graphics from love

class element
    new: (pop, parent) =>
        @parent = parent
        @child = {}

        @x = parent.x or 0
        @y = parent.y or 0
        @w = 10
        @h = 10

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
        @x += x
        @y += y

        for i = 1, #@child
            if not @child[i].excludeMovement
                @child[i]\move x, y

        return @

    setPosition: (x, y) =>
        oldX = @x
        oldY = @y

        switch @horizontal
            when "left"
                @x = x
            when "center"
                @x = x - @w/2
            when "right"
                @x = x - @w

        switch @vertical
            when "top"
                @y = y
            when "center"
                @y = y - @h/2
            when "bottom"
                @y = y - @h

        for i = 1, #@child
            if not @child[i].excludeMovement
                @child[i]\move x - oldX, y - oldY

        return @

    getPosition: =>
        resultX = @x
        resultY = @y

        switch @horizontal
            when "center"
                resultX += @w/2
            when "right"
                resultX += @w

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

    adjustSize: (w, h) =>
        W, H = @getSize!

        if w
            W += w
        if h
            H += h

        @setSize W, H

        return @

    align: (horizontal, vertical) =>
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

        return @

    alignTo: (element, horizontal, vertical) =>
        realParent = @parent
        @parent = element

        @align horizontal, vertical

        @parent = realParent

        return @

    setAlignment: (horizontal, vertical) =>
        if horizontal
            @horizontal = horizontal
        if vertical
            @vertical = vertical

        return @
