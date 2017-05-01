--- A generic window element. Built-in support for minimize, maximize, and close
--- buttons, as well as drag-to-resize and drag-to-move. Title bar customizable.
--- @classmod window
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)
--- @todo Implement missing features.

local pop

import graphics, mouse from love

path = (...)\sub 1, -7
element = require "#{path}/element"
box = require "#{path}/box"
text = require "#{path}/text"

path = path\sub 1, -11
maximizeImage = graphics.newImage "#{path}/images/maximize.png"
minimizeImage = graphics.newImage "#{path}/images/minimize.png"
closeImage = graphics.newImage "#{path}/images/close.png"
-- drag to resize is based on area of padding, which defaults to 5 pixels

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

        -- how a window is contained within its parent element
        @data.containMethod = "mouse" unless @data.containMethod

        @data.maximized = false
        @data.maximizeable = false if @data.maximizeable == nil
        @data.minimizeable = false if @data.minimizeable == nil
        @data.closeable = false if @data.closeable == nil
        unless @data.previous
            @data.previous = {}

        @header = pop.box @, @data.titleBackground or {25, 180, 230, 255}
        @title = pop.text @header, {horizontal: "center"}, title, @data.titleColor or {255, 255, 255, 255}
        @window_area = pop.box @, {padding: 5}, @data.windowBackground or {200, 200, 210, 255}

        -- buttons! :D
        @data.header_width_reduction = 0
        buttonSize = @title\getHeight! + 1
        if @data.closeable
            @closeButton = pop.box(@, {w: buttonSize, h: buttonSize, horizontalMargin: @data.header_width_reduction}, closeImage)\align "right"
            @closeButton.clicked = (x, y, button) =>
                if button == pop.constants.left_mouse
                    @parent\close!
            @data.header_width_reduction += buttonSize
        if @data.maximizeable
            @maximizeButton = pop.box(@, {w: buttonSize, h: buttonSize, horizontalMargin: @data.header_width_reduction}, maximizeImage)\align "right"
            @maximizeButton.clicked = (x, y, button) =>
                if button == pop.constants.left_mouse
                    @parent\maximize!
            @data.header_width_reduction += buttonSize
        if @data.minimizeable
            @minimizeButton = pop.box(@, {w: buttonSize, h: buttonSize, horizontalMargin: @data.header_width_reduction}, minimizeImage)\align "right"
            @minimizeButton.clicked = (x, y, button) =>
                if button == pop.constants.left_mouse
                    @parent\minimize!
            @data.header_width_reduction += buttonSize

        height = @title\getHeight! + 1
        @header\setSize @data.w - @data.header_width_reduction, height
        @window_area\setSize @data.w, @data.h - height
        @window_area\move nil, height

        -- window area steals mouse events to prevent propagation to elements under it
        @window_area.mousepressed = (x, y, button) =>
            if button == pop.constants.left_mouse
                grandparent = @parent.parent
                table.insert grandparent.child, table.remove(grandparent.child, grandparent\indexOf @parent)
            return nil
        @window_area.clicked = =>
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
        if @closeButton
            @closeButton\align!
        if @maximizeButton
            @maximizeButton\align!
        if @minimizeButton
            @minimizeButton\align!

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

            @header\setWidth w - @data.header_width_reduction
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

    setPadding: (padding) =>
        @window_area\setPadding padding
        return @

    getPadding: =>
        return @window_area\getPadding!

    maximize: =>
        if @data.maximized
            @data.x = @data.previous.x
            @data.y = @data.previous.y
            @setSize @data.previous.w, @data.previous.h
        else
            @data.previous.x = @data.x
            @data.previous.y = @data.y
            @data.previous.w = @data.w
            @data.previous.h = @data.h
            @data.x = @parent.data.x
            @data.y = @parent.data.y
            @setSize @parent.data.w, @parent.data.h
            table.insert @parent.child, table.remove(@parent.child, @parent\indexOf @)
        @data.maximized = not @data.maximized
        @align!
        return @

    minimize: =>
        @data.draw = false
        return @

    close: =>
        @delete!
