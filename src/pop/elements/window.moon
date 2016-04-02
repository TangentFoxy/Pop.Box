import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/window"
element = require "#{path}/element"
box = require "#{path}/box"
text = require "#{path}/text"

-- version compatibility
left = 1          -- what is the left mouse button?
move_event = true -- is the mousemoved event available?

do
    major, minor, revision = love.getVersion!
    if (major == 0) and (minor == 10) and ((revision == 0) or (revision == 1))
        left = 1 -- redundant, but whatever
    if (major == 0) and (minor == 9)
        left = "l"
        if revision == 1
            move_event = false
    else
        print "elements/window: unrecognized LÖVE version: #{major}.#{minor}.#{revision}"
        print "                 assuming LÖVE version > 0.10.1  (there may be bugs)"

class window extends element
    new: (parent, title="window", tBackground={25, 180, 230, 255}, tColor={255, 255, 255, 255}, wBackground={200, 200, 210, 255}) =>
        super parent

        @head = box @, tBackground       -- title box at top
        @title = text @, title, tColor   -- text at top
        @window = box @, wBackground     -- main window area

        -- correct placement / sizes of elements
        height = @title\getHeight!
        @head\setSize @w, height
        @window\move nil, height
        @setSize 100, 80

        -- our child elements are still child elements
        @child = {
            @head, @title, @window
        }

        --@selected = false -- whether or not the window title (and thus, the window) has been selected
        --NOTE all of these commented out, because I realized these event handlers should be attached to the title element

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 200, 0, 200, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 255, 200, 255, 255
        graphics.print "w", @x, @y

        return @

    --update: =>
        -- if selected, set position based on current mouse position relative to position it was when mousepressed

    --mousemoved: (x, y, dx, dy) =>
        -- if selected, set position based on new mouse position relative to position it was when mousepressed

    --mousepressed: (x, y, button) =>
        -- if button == "l" -> selected = true, mouse position saved

    --mousereleased: (x, y, button) =>
        -- if button == "l" -> set position based on position relative to when mousepressed, selected == false

    setSize: (w, h) =>
        x = 0
        y = 0

        if w
            switch @horizontal
                when "center"
                    x -= (w - @w)/2
                when "right"
                    x -= w - @w

            @head\setWidth w
            @window\setWidth w
            @w = w
            @x += x

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
        @title\move x, y
        @window\move x, y

        return @

    setWidth: (w) =>
        x = 0

        switch @horizontal
            when "center"
                x -= (w - @w)/2
            when "right"
                x -= w - @w

        @head\setWidth w
        @window\setWidth w
        @w = w
        @x += x

        @head\move x
        @title\move x
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

        @head\move x, y
        @title\move x, y
        @window\move x, y

        return @
