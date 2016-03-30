import graphics from love
import sub, len from string

path = sub ..., 1, len(...) - len "/window"
element = require "#{path}/element"
box = require "#{path}/box"
text = require "#{path}/text"

class window extends element
    new: (parent, title="window", tBackground={25, 180, 230, 255}) =>
        super parent

        @head = box @, tBackground       -- title box at top
        @title = text @, title           -- text at top
        @window = box @, {0,0,0,255}     -- main window area

        -- correct placement / sizes of elements
        height = @title\getHeight!
        @head\setSize @w, height
        @window\move nil, height
        @setSize 100, 80

        -- our child elements are still child elements
        @child = {
            @head, @title, @window
        }

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @x, @y, @w, @h
        graphics.setColor 200, 0, 200, 200
        graphics.rectangle "line", @x, @y, @w, @h
        graphics.setColor 255, 200, 255, 255
        graphics.print "w", @x, @y

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
