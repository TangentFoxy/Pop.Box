import graphics from love
import floor from math
import insert, remove from table
tonumber = tonumber

class element
    new: (parent) =>

        @data = {
            parent: parent
            child: {}

            w: 0
            h: 0
            x: 0
            y: 0

            horizontal: "left"
            vertical: "top"
            margin: 0

            draw: true
            update: true
            move: true
        }

        if parent
            @data.x = parent.data.x
            @data.y = parent.data.y
            --@data.horizontal = parent.data.horizontal
            --@data.vertical = parent.data.vertical
            --@align!

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 0, 200, 0, 200
        graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 200, 255, 200, 255
        graphics.print "e", @data.x, @data.y

        return @

    addChild: (child) =>
        -- make sure we don't duplicate references
        if child.data.parent
            child.data.parent\removeChild child

        insert @data.child, child
        child.data.parent = @

        child\align! --NOTE not 100% sure if this is a good idea

        return @

    -- remove child by index OR by reference and return it
    --NOTE API CHANGE HERE MIGHT'VE FUCKED A THING
    removeChild: (child) =>
        if tonumber(child) == child
            -- remove indexed child, return it
            @data.child[child].data.parent = false
            return remove @data.child, child
        else
            for k,v in ipairs @data.child
                if v == child
                    return remove @data.child, k --NOTE might break due to modifying table while indexing it? shouldn't as it returns...
            return "Element \"#{child}\" is not a child of element \"#{@}\". Cannot remove it."
            -- returning an error string instead of erroring is kind of bad, but needed for window to function...

    getChildren: =>
        return @data.child

    --focusChild: (child) =>
    --    insert @data.child, 1, @removeChild(child)
    --    return @

    move: (x, y) =>
        if x
            @data.x = @data.x + x
        if y
            @data.y = @data.y + y

        for i = 1, #@data.child
            --unless @data.child[i].excludeMovement
            if @data.child[i].data.move
                @data.child[i]\move x, y

        return @

    setPosition: (x, y) =>
        oldX = @data.x
        oldY = @data.y

        if x
            switch @data.horizontal
                when "left"
                    @data.x = x
                when "center"
                    @data.x = x - @data.w/2
                when "right"
                    @data.x = x - @data.w
        else
            x = oldX

        if y
            switch @data.vertical
                when "top"
                    @data.y = y
                when "center"
                    @data.y = y - @data.h/2
                when "bottom"
                    @data.y = y - @data.h
        else
            y = oldY

        for i = 1, #@data.child
            @data.child[i]\move x - oldX, y - oldY

        return @

    getPosition: =>
        resultX = @data.x
        resultY = @data.y

        switch @data.horizontal
            when "center"
                resultX += @data.w/2
            when "right"
                resultY += @data.w

        switch @data.vertical
            when "center"
                resultY += @data.h/2
            when "bottom"
                resultY += @data.h

        return resultX, resultY

    setSize: (w, h) =>
        if w
            switch @data.horizontal
                when "center"
                    @data.x -= (w - @data.w)/2
                when "right"
                    @data.x -= w - @data.w

            @data.w = w

        if h
            switch @data.vertical
                when "center"
                    @data.y -= (h - @data.h)/2
                when "bottom"
                    @data.y -= h - @data.h

            @data.h = h

        return @

    getSize: =>
        return @data.w, @data.h

    setWidth: (w) =>
        switch @data.horizontal
            when "center"
                @data.x -= (w - @data.w)/2
            when "right"
                @data.x -= w - @data.w

        @data.w = w

        return @

    getWidth: =>
        return @data.w

    setHeight: (h) =>
        switch @data.vertical
            when "center"
                @data.y -= (h - @data.h)/2
            when "bottom"
                @data.y -= h - @data.h

        @data.h = h

        return @

    getHeight: =>
        return @data.h

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

        @data.x = @data.parent.data.x
        @data.y = @data.parent.data.y

        switch @data.horizontal
            when "left"
                @data.x += @data.margin
            when "center"
                @data.x += (@data.parent.data.w - @data.w)/2
            when "right"
                @data.x += @data.parent.data.w - @data.w - @data.margin

        switch @data.vertical
            when "top"
                @data.y += @data.margin
            when "center"
                @data.y += (@data.parent.data.h - @data.h)/2
            when "bottom"
                @data.y += @data.parent.data.h - @data.h - @data.margin

        if toPixel
            @data.x = floor @data.x
            @data.y = floor @data.y

        --NOTE why does align not move or align children? maybe it's good that it doesn't, maybe it's bad

        return @

    alignTo: (element, horizontal, vertical, toPixel=true) =>
        parent = @data.parent
        @data.parent = element

        @align horizontal, vertical, toPixel

        @data.parent = parent

        return @

    setAlignment: (horizontal, vertical) =>
        if horizontal
            @data.horizontal = horizontal
        if vertical
            @data.vertical = vertical

        return @

    getAlignment: =>
        return @data.horizontal, @data.vertical

    setMargin: (margin) =>
        @data.margin = margin
        @align!
        return @

    getMargin: =>
        return @data.margin

    fill: =>
        @data.x = @data.parent.data.x + @data.margin
        @data.y = @data.parent.data.y + @data.margin
        @data.w = @data.parent.data.w - @data.margin*2
        @data.h = @data.parent.data.h - @data.margin*2

    delete: =>
        for k,v in ipairs @data.child
            v\delete!

        @data.parent\removeChild @
        --@data.child = nil --not 100% sure if this is needed
        --@data = nil       -- pretty sure this .. actually has no effect for why I added it
        @ = nil
        return nil

    getVisibility: =>
        return @data.draw

    setVisibility: (isVisible) =>
        @data.draw = isVisible
        return @

    getStatic: =>
        return (not @data.move)

    setStatic: (isStatic) =>
        @data.move = (not isStatic)
        return @
