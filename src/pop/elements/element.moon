import graphics from love
import floor from math
import insert, remove from table
tonumber = tonumber

class element
    new: (parent) =>
        @parent = parent
        @child = {}

        @w = 0
        @h = 0

        @spacing = 0

        if parent
            @x = parent.x
            @y = parent.y
            --@horizontal = parent.horizontal
            --@vertical = parent.vertical
            --@align!
        else
            @x = 0
            @y = 0
            --@horizontal = "left"
            --@vertical = "top"

        @horizontal = "left"
        @vertical = "top"

        @excludeDraw = false
        @excludeUpdate = false
        @excludeMovement = false

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 0, 200, 0, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 200, 255, 200, 255
        graphics.print "e", @x, @y

        return @

    addChild: (child) =>
        -- make sure we don't duplicate references
        if child.parent
            child.parent\removeChild child

        insert @child, child
        child.parent = @

        child\align! --NOTE not 100% sure if this is a good idea

        return @

    -- remove child by index OR by reference and return it
    --NOTE API CHANGE HERE MIGHT'VE FUCKED A THING
    removeChild: (child) =>
        if tonumber(child) == child
            -- remove indexed child, return it
            @child[child].parent = false
            return remove @child, child
        else
            for k,v in ipairs @child
                if v == child
                    return remove @child, k
            return "Element \"#{child}\" is not a child of element \"#{@}\". Cannot remove it."

    getChildren: =>
        return @child

    --focusChild: (child) =>
    --    insert @child, 1, @removeChild(child)
    --    return @

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
    align: (horizontal, vertical, toPixel=true) =>
        @setAlignment horizontal, vertical

        @x = @parent.x
        @y = @parent.y

        switch @horizontal
            when "left"
                @x += @spacing
            when "center"
                @x += (@parent.w - @w)/2
            when "right"
                @x += @parent.w - @w - @spacing

        switch @vertical
            when "top"
                @y += @spacing
            when "center"
                @y += (@parent.h - @h)/2
            when "bottom"
                @y += @parent.h - @h - @spacing

        if toPixel
            @x = floor @x
            @y = floor @y

        return @

    alignTo: (element, horizontal, vertical, toPixel=true) =>
        parent = @parent
        @parent = element

        @align horizontal, vertical, toPixel

        @parent = parent

        return @

    setAlignment: (horizontal, vertical) =>
        if horizontal
            @horizontal = horizontal
        if vertical
            @vertical = vertical

        return @

    getAlignment: =>
        return @horizontal, @vertical

    setMargin: (spacing) =>
        @spacing = spacing
        @align!
        return @

    getMargin: =>
        return @spacing

    fill: =>
        @x = @parent.x + @spacing
        @y = @parent.y + @spacing
        @w = @parent.w - @spacing*2
        @h = @parent.h - @spacing*2

    delete: =>
        for k,v in ipairs @child
            v\delete!

        @parent\removeChild @
        @ = nil
        return nil

    getVisibility: =>
        return (not @excludeDraw)

    setVisibility: (isVisible) =>
        @excludeDraw = (not isVisible)
        return @

    getStatic: =>
        return @excludeMovement

    setStatic: (isStatic) =>
        @excludeMovement = isStatic
        return @
