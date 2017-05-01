--- A generic element every element must inherit from.
--- @classmod element
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

import graphics from love
import floor, max from math

class element
    --- Constructor expects nothing, or a data table describing it.
    --- @tparam ?Element|false parent The parent element.
    --- @tparam table data[opt] The data (state) for this element.
    --- @treturn element self
    new: (@parent, @data={}) =>
        if type(@data) != "table"
            @data = {}

        @data.parent = false unless @data.parent
        @data.child = {} unless @data.child
        @data.type = "element" unless @data.type

        unless @data.x
            if @parent
                @data.x = @parent.data.x
            else
                @data.x = 0
        unless @data.y
            if @parent
                @data.y = @parent.data.y
            else
                @data.y = 0
        @data.w = 0 unless @data.w
        @data.h = 0 unless @data.h

        @data.update = true if @data.update == nil
        @data.draw = true if @data.draw == nil
        @data.hoverable = true if @data.hoverable == nil
        --@data.static = false if @data.static == nil

        @data.align = true if (@data.align == nil) and @parent
        @data.vertical = "top" unless @data.vertical
        @data.horizontal = "left" unless @data.horizontal

        @data.margin = 0 unless @data.margin
        @data.horizontalMargin = 0 unless @data.horizontalMargin
        @data.verticalMargin = 0 unless @data.verticalMargin

        @data.padding = 0 unless @data.padding
        @data.horizontalPadding = 0 unless @data.horizontalPadding
        @data.verticalPadding = 0 unless @data.verticalPadding

        @child = {}

    --- @todo doc me
    align: (horizontal, vertical, toPixel=true) =>
        unless @data.align return @

        @data.horizontal = horizontal if horizontal
        @data.vertical = vertical if vertical

        @data.x = @parent.data.x
        @data.y = @parent.data.y

        switch @data.horizontal
            when "left"
                @data.x += max(@parent.data.padding + @parent.data.horizontalPadding, @data.margin + @data.horizontalMargin)
            when "center"
                @data.x += (@parent.data.w - @data.w) / 2
            when "right"
                @data.x += @parent.data.w - @data.w - max(@parent.data.padding + @parent.data.horizontalPadding, @data.margin + @data.horizontalMargin)

        switch @data.vertical
            when "top"
                @data.y += @parent.data.padding + @data.margin + @data.verticalMargin
            when "center"
                @data.y += (@parent.data.h - @data.h) / 2
            when "bottom"
                @data.y += @parent.data.h - @data.h - max(@parent.data.padding + @parent.data.verticalPadding, @data.margin + @data.verticalMargin)

        if toPixel
            @data.x = floor @data.x
            @data.y = floor @data.y

        return @

    --- @todo document this
    setPosition: (x, y, toPixel=true) =>
        dx, dy = @data.x, @data.y

        if x
            @data.x = x
            switch @data.horizontal
                when "center"
                    @data.x -= @data.w / 2
                when "right"
                    @data.x -= @data.w

        if y
            @data.y = y
            switch @data.vertical
                when "center"
                    @data.y -= @data.h / 2
                when "bottom"
                    @data.y -= @data.h

        if toPixel
            @data.x = floor @data.x
            @data.y = floor @data.y

        -- new minus old is difference that children need to be moved
        dx = @data.x - dx
        dy = @data.y - dy
        for child in *@child
            child\move dx, dy

        return @

    --- @todo doc me
    getPosition: =>
        x, y = @data.x, @data.y

        switch @data.horizontal
            when "center"
                x += @data.w / 2
            when "right"
                y += @data.w

        switch @data.vertical
            when "center"
                y += @data.h / 2
            when "bottom"
                y += @data.h

        return x, y

    --- Sets an element's width/height. Fixes alignment if needed.
    --- @tparam integer w[opt] Width.
    --- @tparam integer h[opt] Height.
    --- @treturn element self
    setSize: (w, h) =>
        if w
            @data.w = w
        if h
            @data.h = h

        @align!

        return @

    --- Returns an element's width and height.
    --- @treturn integer Width.
    --- @treturn integer Height.
    getSize: =>
        return @data.w, @data.h

    --- Sets an element's width.
    --- @tparam integer w Width.
    --- @treturn element self
    setWidth: (w) =>
        @data.w = w
        @align!
        return @

    --- Returns an element's width.
    --- @treturn integer Width.
    getWidth: =>
        return @data.w

    --- Sets an element's height.
    --- @tparam integer h Height.
    --- @treturn element self
    setHeight: (h) =>
        @data.h = h
        @align!
        return @

    --- Returns an element's height.
    --- @treturn integer Height.
    getHeight: =>
        return @data.h

    --- @todo doc me
    adjustSize: (w, h) =>
        W, H = @getSize!

        if w
            W += w
        if h
            H += h

        @setSize W, H

        return @

    --- Moves an element by specified x/y.
    --- @treturn element self
    move: (x=0, y=0) =>
        --if @data.static return @

        @data.x += x
        @data.y += y

        for child in *@child
            child\move x, y

        return @

    setPadding: (padding) =>
        @data.padding = padding
        @align!
        return @

    getPadding: =>
        return @data.padding

    indexOf: (element) =>
        for i = 1, #@child
            if @child[i] == element
                return i

    dataIndexOf: (data) =>
        for i = 1, #@data.child
            if @data.child[i] == data
                return i

    --- Deletes references to this element and then deletes it.
    delete: =>
        for i=#@child, 1, -1
            @child[i]\delete!

        if @parent
            for i=1, #@parent.child
                if @parent.child[i] == @
                    table.remove @parent.child, i
                    break

        if @parent
            for i=1, #@parent.data.child
                if @parent.data.child[i] == @data
                    table.remove @parent.data.child, i
                    break

        @parent = nil
        @data.parent = nil -- should be for all @ -> nil MAYBE
        @ = nil
        -- DO NOT DELETE @data though, it could still be in use
