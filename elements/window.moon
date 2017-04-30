--- A generic window element. Built-in support for minimize, maximize, and close
--- buttons, as well as drag-to-resize and drag-to-move. Title bar customizable.
--- @classmod window
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)
--- @todo Implement missing features.

local pop

import mouse from love

path = (...)\sub 1, -7
element = require "#{path}/element"
box = require "#{path}/box"
text = require "#{path}/text"

-- images would go here

class window extends element
    load: (pop_lib) ->
        pop = pop_lib

    --- Constructor expects nothing, or a data table describing it.
    --- @todo document containMethod values
    new: (@parent, @data={}, title="Window") =>
        super @parent, @data

        @data.type = "window"
        @data.w = 100 unless @data.w > 0
        @data.h = 80 unless @data.h > 0
        @data.containMethod = "mouse" unless @data.containMethod

        @header = pop.box @, @data.titleBackground or {25, 180, 230, 255}
        @title = pop.text @header, {horizontal: "center"}, title, @data.titleColor or {255, 255, 255, 255}
        @window_area = pop.box @, @data.windowBackground or {200, 200, 210, 255}
        -- closeButton, minimizeButton, etc

        height = @title\getHeight!
        @header\setSize @data.w, height
        @window_area\setSize @data.w, @data.h - height
        @window_area\move nil, height

        -- window area steals mouse events to prevent propagation to elements under it
        @window_area.mousepressed = (x, y, button) ->
            -- attempted to also make them pull to foreground, but it doesn't work
            if button == pop.constants.left_mouse
                grandparent = @parent.parent
                table.insert grandparent.child, table.remove(grandparent.child, grandparent\indexOf @parent)
            return nil
        @window_area.clicked = ->
            return nil

        selected = false
        mx = 0
        my = 0

        @header.mousemoved = (x, y, dx, dy) =>
            if selected
                @parent\move dx, dy
                -- do not leave area of grandparent (based on containMethod)
                grandparent = @parent.parent
                switch @parent.data.containMethod
                    when "title" -- the window title can't leave
                        @parent\move(grandparent.data.x - @data.x) if @data.x < grandparent.data.x
                        @parent\move(nil, grandparent.data.y - @data.y) if @data.y < grandparent.data.y
                        @parent\move(grandparent.data.x + grandparent.data.w - (@data.x + @data.w)) if @data.x + @data.w > grandparent.data.x + grandparent.data.w
                        @parent\move(nil, grandparent.data.y + grandparent.data.h - (@data.y + @data.h)) if @data.y + @data.h > grandparent.data.y + grandparent.data.h
                    when "body" -- the entire window can't leave
                        @parent\move(grandparent.data.x - @data.x) if @data.x < grandparent.data.x
                        @parent\move(nil, grandparent.data.y - @data.y) if @data.y < grandparent.data.y
                        @parent\move(grandparent.data.x + grandparent.data.w - (@parent.data.x + @parent.data.w)) if @parent.data.x + @parent.data.w > grandparent.data.x + grandparent.data.w
                        @parent\move(nil, grandparent.data.y + grandparent.data.h - (@parent.data.y + @parent.data.h)) if @parent.data.y + @parent.data.h > grandparent.data.y + grandparent.data.h
                    when "mouse" -- wherever the mouse has clicked can't leave
                        @parent\setPosition(grandparent.data.x + @data.w - mx) if mouse.getX! < grandparent.data.x
                        @parent\setPosition(nil, grandparent.data.y + @parent.data.h - my) if mouse.getY! < grandparent.data.y
                        @parent\setPosition(grandparent.data.x + grandparent.data.w + @data.w - mx) if mouse.getX! > grandparent.data.x + grandparent.data.w
                        @parent\setPosition(nil, grandparent.data.y + grandparent.data.h + @parent.data.h - my) if mouse.getY! > grandparent.data.y + grandparent.data.h
                return true
            return false

        @header.mousepressed = (x, y, button) =>
            if button == pop.constants.left_mouse
                grandparent = @parent.parent
                table.insert grandparent.child, table.remove(grandparent.child, grandparent\indexOf @parent)
                selected = true
                mx = x
                my = y
                return true
            return false

        @header.mousereleased = (x, y, button) =>
            if button == pop.constants.left_mouse
                selected = false
                --pop.focused = false -- we have to manually clear our focus
                return true
            return false

        -- unsure if needed or how needed
        --@setSize @data.w, @data.h -- or 100, 80
        @align!

    align: (...) =>
        unless @data.align return @
        super ...

        -- don't know if this is needed or why
        --for i = 1, #@child
        --    @child[i]\align!
        @header\align!
        @title\align!
        @window_area\align!

        @window_area\move nil, @header\getHeight!

        return @

    setSize: (w, h) =>
        x = 0
        y = 0

        if w
            switch @data.horizontal
                when "center"
                    x -= (w - @data.w) / 2
                when "right"
                    x -= w - @data.w

            -- close button stuff

            @header\setWidth w
            @window_area\setWidth w
            @data.w = w
            @data.x += x

            @title\align!

            -- close button stuff 2 ?

        if h
            switch @data.vertical
                when "center"
                    y -= (h - @data.h) / 2
                when "right"
                    y -= h - @data.h

            @window_area\setHeight h - @header\getHeight!
            @window_area\move nil, @header\getHeight!
            @data.h = h
            @data.y += y

        @header\move x, y
        @window_area\move x, y

        return @

    setWidth: (w) =>
        return @setSize w

    setHeight: (h) =>
        return @setSize nil, h
