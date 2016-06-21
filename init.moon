--- The Pop.Box GUI itself.
--- @module pop
--- @copyright Paul Liverman III (2015-2016)
--- @license The MIT License (MIT)
--- @release v0.0.0

pop = {
    _VERSION: 'Pop.Box v0.0.0'
    _DESCRIPTION: 'GUI library for LOVE, designed for ease of use'
    _URL: 'http://github.com/Guard13007/Pop.Box'
    _LICENSE: 'The MIT License (MIT)'
    _AUTHOR: 'Paul Liverman III'
}

unless love.getVersion
    error "Pop.Box only supports LOVE versions >= 0.9.1"

--- @todo Find out what happens if someone requires the `init.lua` / `init.moon` file instead of the directory, add an error message for this.

import filesystem, graphics from love
import insert from table
import inheritsFromElement from require "#{...}/util"

path = ...

--- @table pop
--- @field elements All GUI classes are stored here.
--- @field skins All skins are stored here.
--- @field screen The top level GUI element. Represents the game screen. Initialized in `pop.load()`
--- @see pop.load
--- @field focused The currently focused GUI element (or false if none is focused).

pop.elements = {}
pop.skins = {}
pop.screen = false
pop.focused = false



--- Loads elements, skins, extensions, and initializes `pop.screen`. **IMPORTANT**: Intended to only be called once, and is automatically called when you require Pop.Box.
--- @function load
--- @see pop
--- @todo @see Elements
--- @todo @see Skins
--- @todo @see Extensions

pop.load = ->
    elements = filesystem.getDirectoryItems "#{path}/elements"
    for i = 1, #elements
        -- ignore non-Lua files
        unless elements[i]\sub(-4) == ".lua"
            continue

        -- require into pop.elements table by filename
        name = elements[i]\sub 1, -5
        pop.elements[name] = require "#{path}/elements/#{name}"

        -- call the element's load function if it exists
        if pop.elements[name].load
            pop.elements[name].load pop

        print "element loaded: \"#{name}\""

        -- create "pop.element()" function wrapper if possible
        unless pop[name]
            if pop.elements[name].wrap
                pop[name] = pop.elements[name].wrap pop
            else
                pop[name] = (...) ->
                    return pop.create(name, ...)

            print "wrapper created: \"pop.#{name}()\""


    skins = filesystem.getDirectoryItems "#{path}/skins"
    for i = 1, #skins
        -- ignore non-Lua files
        unless skins[i]\sub(-4) == ".lua"
            continue

        -- require into pop.skins table by filename
        name = skins[i]\sub 1, -5
        pop.skins[name] = require "#{path}/skins/#{name}"

        -- call the skin's load function if it exists
        if pop.skins[name].load
            pop.skins[name].load pop

        print "skin loaded: \"#{name}\""


    extensions = filesystem.getDirectoryItems "#{path}/extensions"
    for i = 1, #extensions
        -- ignore non-Lua files
        unless extensions[i]\sub(-4) == ".lua"
            continue

        --- @todo Determine if extensions should have a reference saved (and the possibility of a load function?)
        -- require into pop.extensions by filename
        name = extensions[i]\sub 1, -5
        require "#{path}/extensions/#{name}"

        print "extension loaded: \"#{name}\""


    -- Initialize pop.screen (top element, GUI area)
    pop.screen = pop.create("element", false)\setSize(graphics.getWidth!, graphics.getHeight!)
    print "created \"pop.screen\""



--- Creates an element.
--- @function create
--- @param element A string naming the element class to use.
--- @param parent *Optional* The parent element. If `false`, an element is created with no parent. If `nil`, defaults to `pop.screen`.
--- (**Note**: An element with no parent will not be handled by Pop.Box's event handlers unless you handle it explicitly.)
--- @see pop
--- @todo @see Elements

pop.create = (element, parent=pop.screen, ...) ->
    -- if valid parent element, use it
    if inheritsFromElement parent
        element = pop.elements[element](parent, ...)
        insert parent.child, element
        insert parent.data.child, element.data
    -- if explicitly no parent, just create the element
    elseif parent == false
        element = pop.elements[element](false, ...)
    -- else use pop.screen (and "parent" is actually the first argument)
    else
        element = pop.elements[element](pop.screen, parent, ...)
        insert pop.screen.child, element
        insert pop.screen.data.child, element.data

    return element



--- Event handler for `love.update()`.
--- @function update
--- @param dt The amount of time passed since the last call to update, in seconds.
--- @param element *Optional* The element to update. Defaults to `pop.screen` (and loops through all its children).
--- @todo Define Elements and @see that documentation from here. Generic documentation, not specifically element!

pop.update = (dt, element=pop.screen) ->
    -- data.update boolean controls an element and its children being updated
    if element.data.update
        if element.update
            element\update dt
        for i = 1, #element.child
            pop.update dt, element.child[i]



--- Event handler for `love.draw()`.
--- @function draw
--- @param element *Optional* The element to draw. Defaults to `pop.screen` (and loops through all its children).
--- @todo @see Elements

pop.draw = (element=pop.screen) ->
    -- data.draw boolean controls an element and its children being drawn
    if element.data.draw
        if element.draw
            element\draw!
        for i = 1, #element.child
            pop.draw element.child[i]



--- Event handler for `love.mousemoved()`. (*LÖVE >= 0.10.0*)
--- @function mousemoved
--- @param x The x coordinate of the mouse.
--- @param y The y coordinate of the mouse.
--- @param dx The distance on the x axis the mouse was moved.
--- @param dy The distance on the y axis the mouse was moved.
--- @return `true` / `false`: Was the event handled?

--- @todo Implement a way for an element to attach itself to `love.mousemoved()` events?
pop.mousemoved = (x, y, dx, dy) ->
    if pop.focused and pop.focused.mousemoved
        return pop.focused\mousemoved x, y, dx, dy

    return false



--- Event handler for `love.mousepressed()`.
--- @function mousepressed
--- @param x The x coordinate of the mouse press.
--- @param y The y coordinate of the mouse press.
--- @param button The mouse button pressed.
--- @param element *Optional* The element to check for event handling. Defaults to `pop.screen` (and loops through all its children).
--- @return `true` / `false`: Was the event handled?

pop.mousepressed = (x, y, button, element) ->
    -- start at the screen, print that we received an event
    unless element
        print "mousepressed", x, y, button
        element = pop.screen

    -- have we handled the event?
    handled = false

    -- if it is inside the current element..
    if (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h)
        -- check its child elements in reverse order, returning if something handles it
        for i = #element.child, 1, -1
            if handled = pop.mousepressed x, y, button, element.child[i]
                return handled

        -- if a child hasn't handled it yet (note: this check doesn't seem neccessary)
        unless handled
            -- if we can handle it and are visible, try to handle it, and set pop.focused
            if element.mousepressed and element.data.draw
                if handled = element\mousepressed x - element.data.x, y - element.data.y, button
                    pop.focused = element

    -- return whether or not we have handled the event
    return handled



--- Event handler for `love.mousereleased()`.
--- @function mousereleased
--- @param x The x coordinate of the mouse release.
--- @param y The y coordinate of the mouse release.
--- @param button The mouse button released.
--- @param element *Optional* The element to check for event handling. Defaults to `pop.screen` (and loops through all its children).
--- @return `true` / `false`: Was a click handled?
--- @return `true` / `false`: Was a mouse release handled?

pop.mousereleased = (x, y, button, element) ->
    -- we are trying to handle a clicked or mousereleased event
    clickedHandled = false
    mousereleasedHandled = false

    -- if we have an element, and are within its bounds
    if element
        if (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h)
            -- check its children in reverse for handling a clicked or mousereleased event
            for i = #element.child, 1, -1
                clickedHandled, mousereleasedHandled = pop.mousereleased x, y, button, element.child[i]
                if clickedHandled or mousereleasedHandled
                    return clickedHandled, mousereleasedHandled

            -- if that doesn't work, we try to handle it ourselves (note: again, this check seems unneccessary)
            unless clickedHandled or mousereleasedHandled
                -- clicked only happens on visible elements, mousereleased happens either way
                if element.clicked and element.data.draw
                    clickedHandled = element\clicked x - element.data.x, y - element.data.y, button
                if element.mousereleased
                    mousereleasedHandled = element\mousereleased x - element.data.x, y - element.data.y, button

                -- if we clicked, we're focused!
                if clickedHandled
                    pop.focused = element
                    --- @todo Figure out how to bring a focused element to the front of view (aka the first element in its parent's children).
                    --- (If I do it right here, the for loop above may break! I need to test/figure this out.)
                    --NOTE this might cause an error in the above for loop!
                    -- basically, move focused element to front of its parent's child
                    --element.parent\focusChild element
                    --table.insert element.parent, element.parent\removeChild(element),

    -- else, default to pop.screen to begin! (and print that we received an event)
    else
        print "mousereleased", x, y, button
        pop.mousereleased x, y, button, pop.screen

    return clickedHandled, mousereleasedHandled



--- Event handler for `love.keypressed()`.
--- @function keypressed
--- @param key The key that was pressed.
--- @return `true` / `false`: Was the event handled?

pop.keypressed = (key) ->
    print "keypressed", key

    -- keypressed events must be on visible elements
    element = pop.focused
    if element and element.keypressed and element.data.draw
        return element.keypressed key

    return false



--- Event handler for `love.keyreleased()`.
--- @function keyreleased
--- @param key The key that was released.
--- @return `true` / `false`: Was the event handled?

pop.keyreleased = (key) ->
    print "keyreleased", key

    -- keyreleased events are always called
    element = pop.focused
    if element and element.keyreleased
        return element.keyreleased key

    return false



--- Event handler for `love.textinput()`.
--- @function textinput
--- @param text The text that was typed.
--- @return `true` / `false`: Was the text input handled?

pop.textinput = (text) ->
    print "textinput", text

    -- textinput events must be on visible elements
    element = pop.focused
    if element and element.textinput and element.data.draw
        return element.textinput text

    return false



--- Applies skins to elements. (**NOTE^*: This function will be rewritten and change at some point...)
--- @function skin
--- @param element The element to skin. Defaults to `pop.screen` (and loops through all its children).
--- @param skin The skin to use, can be a string or an actual skin object, defaults to a default skin that is part of Pop.Box.
--- @param depth Can be an integer for how many levels to go skinning. Alternately, if `true`, will skin all children.

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

pop.printElementTree = (element=pop.screen, depth=0) ->
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
