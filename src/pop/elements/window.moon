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

--pop_ref = false -- reference to pop, loaded by pop.load!
-- turns out we don't need it...?

class window extends element
    --TODO IMPLEMENT THIS COMMENTED OUT CHANGE. IT SHOULD WORK THE SAME EXCEPT BE BETTER.
    --@load = (pop) ->
    --load: (pop) ->
    --    pop_ref = pop

    new: (parent, title="window", tBackground={25, 180, 230, 255}, tColor={255, 255, 255, 255}, wBackground={200, 200, 210, 255}) =>
        super parent

        -- NOTE @data.title having @data.head as its parent might break things horribly
        @data.head = box @, tBackground              -- title box at top
        @data.title = text @data.head, title, tColor -- text at top
        @data.area = box @, wBackground              -- main window area
        @data.close = box @, closeImage              -- close button

        -- correct placement / sizes of elements
        height = @data.title\getHeight!
        @data.head\setSize @data.w - height, height
        @data.area\move nil, height
        @data.close\align("right")\setSize height, height
        @setSize 100, 80

        -- our child elements are still child elements
        --NOTE this is needed anywhere an element creates its own children (aka is NOT called through pop.create)
        --     TODO put this note in the dev docs!
        --TODO change title to be a child of head ? title already thinks that head is its parent (look above!)
        @data.child = {
            @data.head, @data.title, @data.area, @data.close
        }

        @data.overflow = "trunicate" -- defaults to trunicating title to fit in window

        -- window area steals mouse events to keep them from propagating under it
        @data.area.mousepressed = ->
            return true
        @data.area.clicked = ->
            return true

        @data.close.clicked = ->
            @delete!
            return true

        @data.head.data.selected = false -- whether or not the window title (and thus, the window) has been selected

        if mousemoved_event
            @data.head.mousemoved = (x, y, dx, dy) =>
                if @data.selected
                    @data.parent\move dx, dy
                    return true
                return false

            @data.head.mousepressed = (x, y, button) =>
                if button == left
                    @data.selected = true
                    return true
                return false

        else
            @data.head.data.mx = 0      -- local mouse coordinates when selected
            @data.head.data.my = 0

            @data.head.update = =>
                x, y = mouse.getPosition!
                @setPosition x - @data.mx, y - @data.my

            @data.head.mousepressed = (x, y, button) =>
                if button == left
                    @data.selected = true
                    @data.mx = x
                    @data.my = y
                    return true
                return false

        @data.head.mousereleased = (x, y, button) =>
            if button == left
                @data.selected = false
                --pop_ref.focused = false -- clear our focus (should this be done? I think not)
                return true
            return false

        --@data.head.focusChild = =>
        --    @data.parent\focusChild @ -- nope
        --    return @

    debugDraw: =>
        graphics.setLineWidth 0.5
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 200, 0, 200, 200
        graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        graphics.setColor 255, 200, 255, 255
        graphics.print "w", @data.x, @data.y

        return @

    addChild: (child) =>
        @data.area\addChild child

        return @

    -- pass through to window, but return us if @data.area returns itself
    --TODO check if that's even possible, with the API change to removeChild, it shouldn't be happening EVER
    removeChild: (child) =>
        result = @data.area\removeChild child
        if result == @data.area
            return @
        elseif type(result) == "string"
            for k,v in ipairs @data.child
                if v == child
                    remove @data.child, k
                    return @
            return "Element \"#{child}\" is not a child of window \"#{@}\". Cannot remove it."
        else
            return result

    getChildren: =>
        return @data.area.child

    --focusChild: =>
    --    @data.parent\focusChild @
    --    --NOTE might need to also actually focus the sub-element
    --    return @

    align: (horizontal, vertical, toPixel) =>
        super horizontal, vertical, toPixel

        for i = 1, #@data.child
            @data.child[i]\align!

        @data.area\move nil, @data.head\getHeight!

        return @

    setSize: (w, h) =>
        x = 0
        y = 0

        if w
            switch @data.horizontal
                when "center"
                    x -= (w - @data.w)/2
                when "right"
                    x -= w - @data.w

            if @data.close
                @data.head\setWidth w - @data.head\getHeight!
            else
                @data.head\setWidth w

            @data.area\setWidth w
            @data.w = w
            @data.x += x

            @data.title\align!

            if @data.close
                @data.close\align!

        if h
            h = h - @data.head\getHeight!
            switch @data.vertical
                when "center"
                    y -= (h - @data.h)/2
                when "right"
                    y -= h - @data.h

            @data.area\setHeight h
            @data.h = h + @data.head\getHeight!
            @data.y += y

        @data.head\move x, y
        --@data.title\move x, y
        @data.area\move x, y

        return @

    setWidth: (w) =>
        x = 0

        switch @data.horizontal
            when "center"
                x -= (w - @data.w)/2
            when "right"
                x -= w - @data.w

        if @data.close
            @data.head\setWidth w - @data.head\getHeight!
        else
            @data.head\setWidth w

        @data.area\setWidth w
        @data.w = w
        @data.x += x

        @data.title\align!

        if @data.close
            @data.close\align!

        @data.head\move x
        --@data.title\move x
        @data.area\move x

        return @

    setHeight: (h) =>
        y = 0

        h = h - @data.head\getHeight!
        switch @data.vertical
            when "center"
                y -= (h - @data.h)/2
            when "right"
                y -= h - @data.h

        @data.area\setHeight h
        @data.h = h + @data.head\getHeight!
        @data.y += y

        @data.head\move nil, y
        @data.title\move nil, y
        @data.area\move nil, y

        return @

    setTitle: (title) =>
        @data.title\setText title

        --NOTE when the entire window is resized, these checks do not get performed..this is probably a bad thing
        --TODO make sure they always get checked, and that a trunicated title is saved so it can be un-trunicated when able
        if @data.overflow == "trunicate"
            while @data.title\getWidth! > @data.head\getWidth!
                title = title\sub 1, -3
                @data.title\setText title .. "…"

        elseif @data.overflow == "resize"
            if @data.title\getWidth! > @data.head\getWidth!
                @setWidth @data.title\getWidth!

        return @

    getTitle: =>
        return @data.title\getText!

    setTitleOverflow: (method) =>
        @data.overflow = method

        return @

    getTitleOverflow: =>
        return @data.overflow

    --TODO make the constructor call this instead of having these methods defined twice...
    setClose: (enabled) =>
        if enabled
            @data.close = box @, closeImage
            @data.close.clicked = ->
                @delete!
                return true
            height = @data.head\getHeight!
            @data.close\align("right")\setSize height, height
            @data.head\setWidth @data.w - height
            @data.title\align!
            insert @data.child, @data.close
        else
            @data.close\delete!
            @data.head\setWidth @data.w
            @data.title\align!
            @data.close = false

        return @

    hasClose: =>
        if @data.close
            return true
        else
            return false

    delete: =>
        super!
        @data.head = nil
        @data.title = nil
        @data.area = nil
        @data.close = nil
        return
