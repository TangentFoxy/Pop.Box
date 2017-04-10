--- A generic element every element must inherit from.
--- @classmod element
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

import graphics from love
import floor from math

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
        @data.x = 0 unless @data.x
        @data.y = 0 unless @data.y
        @data.w = 0 unless @data.w
        @data.h = 0 unless @data.h
        @data.update = true if @data.update == nil
        @data.draw = true if @data.draw == nil
        @data.type = "element" unless @data.type
        @data.align = true if (@data.align == nil) and @parent
        @data.vertical = "top" unless @data.vertical
        @data.horizontal = "left" unless @data.horizontal

        @child = {}

        @align!

    --- Slightly modified from pop.debugDraw
    --- @see pop.debugDraw
    debugDraw: =>
        graphics.setLineWidth 1
        graphics.setColor 0, 20, 0, 100
        graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 150, 255, 150, 150
        graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 200, 255, 200, 255
        graphics.print "e", @data.x, @data.y

        return @

    --- @todo doc me
    align: (horizontal, vertical, toPixel=true) =>
        unless @data.align return @

        @data.horizontal = horizontal if horizontal
        @data.vertical = vertical if vertical

        @data.x = @parent.data.x
        @data.y = @parent.data.y

        switch @data.horizontal
            when "center"
                @data.x += (@parent.data.w - @data.w) / 2
            when "right"
                @data.x += @parent.data.w - @data.w

        switch @data.vertical
            when "center"
                @data.y += (@parent.data.h - @data.h) / 2
            when "bottom"
                @data.y += @parent.data.h - @data.h

        if toPixel
            @data.x = floor @data.x
            @data.y = floor @data.y

        return @

    --- @todo document this
    setPosition: (x, y, toPixel=true) =>
        if x
            @data.x = x
        if y
            @data.y = y

        switch @data.horizontal
            when "center"
                @data.x -= @data.w / 2
            when "right"
                @data.x -= @data.w

        switch @data.vertical
            when "center"
                @data.y -= @data.h / 2
            when "bottom"
                @data.y -= @data.h

        if toPixel
            @data.x = floor @data.x
            @data.y = floor @data.y

        return @

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
        return @

    --- Returns an element's height.
    --- @treturn integer Height.
    getHeight: =>
        return @data.h

    --- Moves an element by specified x/y.
    --- @treturn element self
    move: (x=0, y=0) =>
        @data.x += x
        @data.y += y
        return @

    --- Deletes references to this element and then deletes it.
    delete: =>
      for i=#@child, 1, -1
          @child[i]\delete!

      for i=1, #@parent.child
          if @parent.child[i] == @
              table.remove @parent.child, i
              break

      for i=1, #@parent.data.child
          if @parent.data.child[i] == @data
              table.remove @parent.data.child, i
              break

      @parent = nil
      @data.parent = nil -- should be for all @ -> nil
      --@ = nil <- or that, does that work? Idk
      -- DO NOT DELETE @data though, it could still be in use
