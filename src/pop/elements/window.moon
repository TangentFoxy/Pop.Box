import graphics, mouse from love
import insert, remove from table
import sub, len from string

path = sub ..., 1, len(...) - len "/window"
element = require "#{path}/element"
box = require "#{path}/box"
text = require "#{path}/text"

closeImage = graphics.newImage "#{path}/img/close.png"

-- version compatibility
left = 1                -- what is the left mouse button?
mousemoved_event = true -- is the mousemoved event available?

do
    major, minor, revision = love.getVersion!
    if (major == 0) and (minor == 10) and ((revision == 0) or (revision == 1))
        left = 1 -- redundant, but whatever
    elseif (major == 0) and (minor == 9)
        left = "l"
        if revision == 1
            mousemoved_event = false
    else
        print "elements/window: unrecognized LOVE version: #{major}.#{minor}.#{revision}"
        print "                 assuming LOVE version > 0.10.1  (there may be bugs)"

pop_ref = false -- reference to pop, loaded by pop.load!

class window extends element
    load: (pop) ->
        pop_ref = pop

    new: (parent, title="window", tBackground={25, 180, 230, 255}, tColor={255, 255, 255, 255}, wBackground={200, 200, 210, 255}) =>
        super parent

        -- NOTE @title having @head as its parent might break things horribly
        @head = box @, tBackground         -- title box at top
        @title = text @head, title, tColor -- text at top
        @window = box @, wBackground       -- main window area
        @close = box @, closeImage         -- close button

        -- correct placement / sizes of elements
        height = @title\getHeight!
        @head\setSize @w - height, height
        @window\move nil, height
        @close\align("right")\setSize height, height
        @setSize 100, 80

        -- our child elements are still child elements
        --TODO change title to be a child of head ?
        @child = {
            @head, @title, @window, @close
        }

        @titleOverflow = "trunicate" -- defaults to trunicating title to fit in window

        @close.clicked = ->
            @delete!
            return true

        @head.selected = false -- whether or not the window title (and thus, the window) has been selected

        if mousemoved_event
            @head.mousemoved = (x, y, dx, dy) =>
                if @selected
                    @parent\move dx, dy
                    return true
                return false

            @head.mousepressed = (x, y, button) =>
                if button == left
                    @selected = true
                    return true
                return false

        else
            @head.mx = 0           -- local mouse coordinates when selected
            @head.my = 0

            @head.update = =>
                x, y = mouse.getPosition!
                @setPosition x - mx, y - my
                --return false -- why?

            @head.mousepressed = (x, y, button) =>
                if button == left
                    @selected = true
                    @mx = x
                    @my = y
                    return true
                return false

        @head.mousereleased = (x, y, button) =>
            if button == left
                @selected = false
                pop_ref.focused = false -- clear our focus
                return true
            return false

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 200, 0, 200, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 255, 200, 255, 255
        graphics.print "w", @x, @y

        return @

    addChild: (child) =>
        @window\addChild child

        return @

    -- pass through to window, but return us if window returns itself
    removeChild: (child) =>
        result = @window\removeChild child
        if result == @window
            return @
        elseif type(result) == "string"
            for k,v in ipairs @child
                if v == child
                    remove @child, k
                    return @
            return "Element \"#{child}\" is not a child of window \"#{@}\". Cannot remove it."
        else
            return result

    getChildren: =>
        return @window.child

    align: (horizontal, vertical, toPixel) =>
        super horizontal, vertical, toPixel

        for i = 1, #@child
            @child[i]\align!

        @window\move nil, @head\getHeight!

        return @

    setSize: (w, h) =>
        x = 0
        y = 0

        if w
            switch @horizontal
                when "center"
                    x -= (w - @w)/2
                when "right"
                    x -= w - @w

            if @close
                @head\setWidth w - @head\getHeight!
            else
                @head\setWidth w

            @window\setWidth w
            @w = w
            @x += x

            @title\align!

            if @close
                @close\align!

        if h
            h = h - @head\getHeight!
            switch @vertical
                when "center"
                    y -= (h - @h)/2
                when "right"
                    y -= h - @h

            @window\setHeight h
            @h = h + @head\getHeight!
            @y += y

        @head\move x, y
        --@title\move x, y
        @window\move x, y

        return @

    setWidth: (w) =>
        x = 0

        switch @horizontal
            when "center"
                x -= (w - @w)/2
            when "right"
                x -= w - @w

        if @close
            @head\setWidth w - @head\getHeight!
        else
            @head\setWidth w

        @window\setWidth w
        @w = w
        @x += x

        @title\align!

        if @close
            @close\align!

        @head\move x
        --@title\move x
        @window\move x

        return @

    setHeight: (h) =>
        y = 0

        h = h - @head\getHeight!
        switch @vertical
            when "center"
                y -= (h - @h)/2
            when "right"
                y -= h - @h

        @window\setHeight h
        @h = h + @head\getHeight!
        @y += y

        @head\move nil, y
        @title\move nil, y
        @window\move nil, y

        return @

    setTitle: (title) =>
        @title\setText title

        if @titleOverflow == "trunicate"
            while @title\getWidth! > @head\getWidth!
                title = title\sub 1, -3
                @title\setText title .. "…"

        elseif @titleOverflow == "resize"
            if @title\getWidth! > @head\getWidth!
                @setWidth @title\getWidth!

        return @

    getTitle: =>
        return @title\getText!

    setTitleOverflow: (method) =>
        @titleOverflow = method

        return @

    getTitleOverflow: =>
        return @titleOverflow

    setClose: (enabled) =>
        if enabled
            @close = box @, closeImage
            @close.clicked = ->
                @delete!
                return true
            height = @head\getHeight!
            @close\align("right")\setSize height, height
            @head\setWidth @w - height
            @title\align!
            insert @child, @close
        else
            @close\delete!
            @head\setWidth @w
            @title\align!
            @close = false

        return @

    hasClose: =>
        if @close
            return true
        else
            return false
