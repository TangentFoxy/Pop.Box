pop = {
    _VERSION = 'Pop.Box v0.0.0'
    _DESCRIPTION = 'A GUI library for LOVE.'
    _URL = 'http://github.com/Guard13007/Pop.Box'
    _LICENSE = '
        The MIT License (MIT)

        Copyright (c) 2015-2016 Paul Liverman III

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    '
}

unless love.getVersion
    error "Pop.Box only supports LOVE versions >= 0.9.1"

import filesystem, graphics from love
import insert from table
import inheritsFromElement from require "#{...}/util"

path = ...

pop.elements = {}
pop.skins = {}
--pop.events = {} --NOTE leave this commented out for now, as it may be needed again

pop.screen = false  -- initialized in pop.load()
pop.focused = false

-- loads elements and skins, creates pop.screen (intended to only be called once at the beginning)
pop.load = ->
    elements = filesystem.getDirectoryItems "#{path}/elements"

    for i = 1, #elements
        -- only attempt to load lua files
        unless elements[i]\sub(-4) == ".lua"
            continue

        -- load into pop.elements table
        name = elements[i]\sub 1, -5
        pop.elements[name] = require "#{path}/elements/#{name}"

        if pop.elements[name].load
            pop.elements[name].load pop

        print "element loaded: \"#{name}\""

        -- create pop.element() wrapper if possible
        unless pop[name]
            if pop.elements[name].wrap
                pop[name] = pop.elements[name].wrap pop
            else
                pop[name] = (...) ->
                    return pop.create(name, ...)

            print "wrapper created: \"pop.#{name}()\""

    -- works just like above, except no wrappers
    skins = filesystem.getDirectoryItems "#{path}/skins"

    for i = 1, #skins
        unless skins[i]\sub(-4) == ".lua"
            continue

        name = skins[i]\sub 1, -5
        pop.skins[name] = require "#{path}/skins/#{name}"

        print "skin loaded: \"#{name}\""

    -- load extensions by just running them via require
    extensions = filesystem.getDirectoryItems "#{path}/extensions"

    for i = 1, #extensions
        unless extensions[i]\sub(-4) == ".lua"
            continue

        name = extensions[i]\sub 1, -5
        require "#{path}/extensions/#{name}"

        print "extension loaded: \"#{name}\""

    -- main window (called screen because there is a window element class)
    pop.screen = pop.create("element", false)\setSize(graphics.getWidth!, graphics.getHeight!)
    print "created \"pop.screen\""

-- creates an element with specified parent (parent can be false or non-existent)
pop.create = (element, parent=pop.screen, ...) ->
    -- if valid parent element (includes default of pop.screen when no parent has been passed)
    if inheritsFromElement parent
        element = pop.elements[element](parent, ...)
        insert parent.child, element
    -- if explicitly no parent
    elseif parent == false
        element = pop.elements[element](false, ...)
    -- else we use pop.screen, and "parent" is actually first argument
    else
        element = pop.elements[element](pop.screen, parent, ...)
        insert pop.screen.child, element

    return element

pop.update = (dt, element=pop.screen) ->
    unless element.excludeUpdate
        if element.update
            element\update dt
        for i = 1, #element.child
            pop.update dt, element.child[i]

pop.draw = (element=pop.screen) ->
    unless element.excludeDraw
        if element.draw
            element\draw!
        for i = 1, #element.child
            pop.draw element.child[i]

pop.mousemoved = (x, y, dx, dy) ->
    if pop.focused and pop.focused.mousemoved
        return pop.focused\mousemoved x, y, dx, dy

    return false

pop.mousepressed = (x, y, button, element) ->
    unless element
        print "mousepressed", x, y, button
        element = pop.screen

    handled = false

    if (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h)
        for i = #element.child, 1, -1
            handled = pop.mousepressed x, y, button, element.child[i]
            if handled
                break

        unless handled
            if element.mousepressed and (not element.excludeDraw)
                if handled = element\mousepressed x - element.x, y - element.y, button
                    pop.focused = element
                    --NOTE this might end up being needed in the future
                    --  if it is, add an ability for a mousepressed handler to cancel saving
                    --  the event, and make sure the window element's area does this
                    --pop.events[button] = element

    return handled

pop.mousereleased = (x, y, button, element) ->
    clickedHandled = false
    mousereleasedHandled = false

    if element
        if (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h)
            for i = #element.child, 1, -1
                clickedHandled, mousereleasedHandled = pop.mousereleased x, y, button, element.child[i]
                if clickedHandled or mousereleasedHandled
                    break

            unless clickedHandled or mousereleasedHandled
                if element.clicked and (not element.excludeDraw)
                    clickedHandled = element\clicked x - element.x, y - element.y, button
                if element.mousereleased
                    mousereleasedHandled = element\mousereleased x - element.x, y - element.y, button

                if clickedHandled
                    pop.focused = element

    --else
    --    print "mousereleased", x, y, button
    --    if element = pop.events[button]
    --        if element.clicked and (not element.excludeDraw) --and (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h)
    --            if clickedHandled = element\clicked x - element.x, y - element.y, button
    --                pop.events[button] = nil

    --        if element.mousereleased
    --            if mousereleasedHandled = element\mousereleased x - element.x, y - element.y, button
    --                pop.events[button] = nil

    --    if (not clickedHandled) and (not mousereleasedHandled)
    --        clickedHandled, mousereleasedHandled = pop.mousereleased x, y, button, pop.screen

    return clickedHandled, mousereleasedHandled

pop.keypressed = (key) ->
    print "keypressed", key

    element = pop.focused
    if element and element.keypressed and (not element.excludeDraw)
        return element.keypressed key

    return false

pop.keyreleased = (key) ->
    print "keyreleased", key

    element = pop.focused
    if element and element.keyreleased
        return element.keyreleased key

    return false

pop.textinput = (text) ->
    print "textinput", text

    element = pop.focused
    if element and element.textinput and (not element.excludeDraw)
        return element.textinput text

    return false

--TODO rewrite skin system to not rely on knowing internals of elements,
--     instead call functions like setColor and setBackground
-- skins an element (and its children unless depth == true or 0)
--  depth can be an integer for how many levels to go down when skinning
--  defaults to pop.screen and the default skin
pop.skin = (element=pop.screen, skin=pop.skins.default, depth) ->
    if element.background and skin.background
        element.background = skin.background
    if element.color and skin.color
        element.color = skin.color
    if element.font and skin.font
        element.font = skin.font

    unless depth or (depth == 0)
        if depth == tonumber depth
            for i = 1, #element.child
                pop.skin element.child[i], skin, depth - 1
        else
            for i = 1, #element.child
                pop.skin element.child[i], skin, false

pop.debugDraw = (element=pop.screen) ->
    if element.debugDraw
        element\debugDraw!
    else
        graphics.setLineWidth 1
        graphics.setLineColor 0, 0, 0, 100
        graphics.rectangle "fill", element.x, element.y, element.w, element.h
        graphics.setColor 150, 150, 150, 150
        graphics.rectangle "line", element.x, element.y, element.w, element.h
        graphics.setColor 200, 200, 200, 255
        graphics.print ".", element.x, element.y

    for i = 1, #element.child
        pop.debugDraw element.child[i]

pop.printElementStack = (element=pop.screen, depth=0) ->
    cls = element.__class.__name

    if cls == "text"
        cls = cls .. " (\"#{element\getText!\gsub "\n", "\\n"}\")"
    elseif cls == "box"
        bg = element\getBackground!

        if type(bg) == "table"
            bg = "#{bg[1]}, #{bg[2]}, #{bg[3]}, #{bg[4]}"

        cls = cls .. " (#{bg})"

    print string.rep("-", depth) .. " #{cls}"

    for i = 1, #element.child
        pop.printElementStack element.child[i], depth + 1

pop.load!

return pop
