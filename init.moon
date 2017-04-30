--- The Pop.Box GUI itself.
--- @module pop
--- @copyright Paul Liverman III (2015-2016)
--- @license The MIT License (MIT)
--- @release 0.0.0

pop = {
    _VERSION: '0.0.0'
    _DESCRIPTION: 'GUI library for LOVE, designed for ease of use'
    _URL: 'http://github.com/Guard13007/Pop.Box'
    _LICENSE: 'The MIT License (MIT)'
    _AUTHOR: 'Paul Liverman III'
}

log = (...) ->
    print "[Pop.Box]", ...

unless love.getVersion
    error "Pop.Box only supports LOVE versions >= 0.9.1"

path = (...)\gsub "%.", "/"

if (...)\sub(-4) == "init"
    path = (...)\sub 1, -5
    unless path
        path = "."

log "Require path detected: \"#{path}\""

import filesystem, graphics from love
import insert from table
import inheritsFromElement from require "#{path}/util"
import dumps, loads from require "#{path}/lib/bitser/bitser"

--- @table pop
--- @tfield constants For now, just stores values to be used with mouse clicks
--- for compatibility with differing LOVE versions.
--- @tfield table elements All GUI classes are stored here.
--- @tfield table skins All skins are stored here.
--- @tfield table extensions All extensions are loaded here.
--- @tfield Element screen The top level GUI element. Represents the game
--- screen. Initialized in `pop.load()`
--- @tfield ?Element|false focused The currently focused GUI element (or `false`
--- if none is focused).
--- @tfield ?Element|false hovered The GUI element the mouse is hovering over
--- (or `false` if none is hovered over).
--- @see pop.load
--- @see Element

major, minor, revision = love.getVersion!
if major == 0 and minor == 9
    pop.constants = {
        left_mouse: "l"
        middle_mouse: "m"
        right_mouse: "r"

        button_4: "x1"
        button_5: "x2"

        -- note: these should not be used
        mouse_wheel_down: "wd"
        mouse_wheel_up: "wu"
    }
elseif major == 0 and minor == 10
    pop.constants = {
        left_mouse: 1
        middle_mouse: 3
        right_mouse: 2
        button_4: 4
        button_5: 5
        --no mouse wheel, may lead to problems?
    }
else
    pop.constants = {} -- this would be an unsupported version currently

pop.elements = {}
pop.skins = {}
pop.extensions = {}
pop.screen = false
pop.focused = false
pop.hovered = false
pop.log = log



--- Loads elements, skins, extensions from a specified path. Initializes
--- `pop.screen` on first call.
---
--- Automatically called when you require Pop.Box for its internals. Subsequent
--- calls can be used to add more elements/skins/extensions.
--- @function load
--- @tparam string[opt] The path to load from. Within this path should be
--- elements, skins, and extensions directories, containing whatever items you
--- want to load.
--- @see Element
--- @todo @ see Skins, see Extensions

pop.load = (load_path=path) ->
    log "Loading elements from \"#{load_path}/elements\""
    elements = filesystem.getDirectoryItems "#{load_path}/elements"
    for i = 1, #elements
        -- ignore non-Lua files
        unless elements[i]\sub(-4) == ".lua"
            log "Ignored non-Lua file \"#{load_path}/elements/#{elements[i]}\""
            continue

        -- require into pop.elements table by filename
        name = elements[i]\sub 1, -5
        log "Requiring \"#{name}\" from \"#{load_path}/elements/#{name}\""
        pop.elements[name] = require "#{load_path}/elements/#{name}"

        -- call the element's load function if it exists
        if pop.elements[name].load
            pop.elements[name].load pop

        log "Element loaded: \"#{name}\""

        -- create "pop.element()" function wrapper if possible
        unless pop[name]
            if pop.elements[name].wrap
                pop[name] = pop.elements[name].wrap pop
            else
                pop[name] = (...) ->
                    return pop.create(name, ...)

            log "Wrapper created: \"pop.#{name}()\""


    skins = filesystem.getDirectoryItems "#{load_path}/skins"
    for i = 1, #skins
        -- ignore non-Lua files
        unless skins[i]\sub(-4) == ".lua"
            log "Ignored non-Lua file \"#{load_path}/skins/#{skins[i]}\""
            continue

        -- require into pop.skins table by filename
        name = skins[i]\sub 1, -5
        log "Requiring \"#{name}\" from \"#{load_path}/skins/#{name}\""
        pop.skins[name] = require "#{load_path}/skins/#{name}"

        -- call the skin's load function if it exists
        if pop.skins[name].load
            pop.skins[name].load pop

        log "Skin loaded: \"#{name}\""


    extensions = filesystem.getDirectoryItems "#{load_path}/extensions"
    for i = 1, #extensions
        -- ignore non-Lua files
        unless extensions[i]\sub(-4) == ".lua"
            log "Ignored non-Lua file \"#{load_path}/extensions/#{extensions[i]}\""
            continue

        -- require into pop.extensions by filename
        name = extensions[i]\sub 1, -5
        log "Requiring \"#{name}\" from \"#{load_path}/extensions/#{name}\""
        pop.extensions[name] = require "#{load_path}/extensions/#{name}"

        -- call the extension's load function if it exists
        if pop.extensions[name].load
            pop.extensions[name].load pop

        log "Extension loaded: \"#{name}\""


    -- Initialize pop.screen (top element, GUI area)
    unless pop.screen
        pop.screen = pop.create("element", false)\setSize(graphics.getWidth!, graphics.getHeight!)
        pop.screen.data.update = true
        log "Created \"pop.screen\""



--- Creates an element.
--- @function create
--- @tparam string element The element class to use.
--- @tparam ?Element|false|nil parent[opt] The parent element. If `false`, an
--- element is created with no parent. If `nil`, defaults to `pop.screen`.
--- @param ...[opt] Any number of parameters can be passed to the constructor
--- for the element.
---
--- (**Note**: An element with no parent will not be handled by Pop.Box's event
--- handlers unless you handle it explicitly.)
--- @see pop
--- @see Element

pop.create = (element, parent=pop.screen, data, ...) ->
    -- if valid parent element, use it
    if inheritsFromElement parent
        if type(data) == "table"
            element = pop.elements[element](parent, data, ...)
        else
            element = pop.elements[element](parent, {}, data, ...)
        insert parent.child, element
        insert parent.data.child, element.data
        --element.parent = parent
        element.data.parent = parent.data
    -- if explicitly no parent, just create the element
    elseif parent == false
        if type(data) == "table"
            element = pop.elements[element](false, data, ...)
        else
            element = pop.elements[element](false, {}, data, ...)
        element.parent = false
        element.data.parent = false
    -- else use pop.screen (and "parent" is actually the first argument)
    else
        if type(parent) == "table" -- then parent must be data table
            element = pop.elements[element](pop.screen, parent, data, ...)
        else -- parent must be an argument
            element = pop.elements[element](pop.screen, {}, parent, data, ...)
        --if type(data) == "table"
        --    element = pop.elements[element](pop.screen, parent, data, ...)
        --else
        --    element = pop.elements[element](pop.screen, parent, {}, data, ...)
        insert pop.screen.child, element
        insert pop.screen.data.child, element.data
        --element.parent = pop.screen
        element.data.parent = pop.screen.data

    return element



--- Event handler for `love.update()`.
--- @function update
--- @tparam number dt The amount of time passed since the last call to update,
--- in seconds.
--- @tparam Element element[opt] The element to update (will update all its
--- children as well). Defaults to `pop.screen`.
--- @see Element

pop.update = (dt, element=pop.screen) ->
    --- @todo Define Elements and @ see that documentation from here. Generic documentation, not specifically element!
    -- data.update boolean controls an element and its children being updated
    if element.data.update
        if element.update
            element\update dt
        for i = 1, #element.child
            pop.update dt, element.child[i]



--- Event handler for `love.draw()`.
--- @function draw
--- @tparam Element element[opt] The element to draw (will draw all its children
--- as well). Defaults to `pop.screen`.
--- @see Element

pop.draw = (element=pop.screen) ->
    -- data.draw boolean controls an element and its children being drawn
    if element.data.draw
        if element.draw
            element\draw!
        for i = 1, #element.child
            pop.draw element.child[i]



--- Event handler for `love.mousemoved()`. (LÖVE >= 0.10.0)
--- @function mousemoved
--- @tparam integer x The x coordinate of the mouse.
--- @tparam integer y The y coordinate of the mouse.
--- @tparam number dx The distance on the x axis the mouse was moved.
--- @tparam number dy The distance on the y axis the mouse was moved.
--- @treturn boolean Was the event handled?

pop.mousemoved = (x, y, dx, dy, element=pop.screen) ->
    -- first we find out if we're hovering over anything and set pop.hovered
    if element.data.draw and element.data.hoverable and (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h)
        -- okay, we're over this element for sure, but let's check its children
        pop.hovered = element
        -- check in reverse order, it will set pop.hovered to any that match
        for i = 1, #element.child
            pop.mousemoved x, y, dx, dy, element.child[i]

    --- @todo Implement a way for an element to attach itself to `love.mousemoved()` events?
    -- checking element against pop.screen so that this only gets called once
    if pop.focused and pop.focused.mousemoved and element == pop.screen
        return pop.focused\mousemoved x - pop.focused.data.x, y - pop.focused.data.y, dx, dy

    return false



--- Event handler for `love.mousepressed()`.
--- @function mousepressed
--- @tparam integer x The x coordinate of the mouse press.
--- @tparam integer y The y coordinate of the mouse press.
--- @tparam ?string|integer button The mouse button pressed. (Type varies by
--- LÖVE version.)
--- @tparam Element element[opt] The element to check for event handling (will
--- check its children as well). Defaults to `pop.screen`.
--- @treturn boolean Was the event handled?
--- @see Element

pop.mousepressed = (x, y, button, element) ->
    -- start at the screen, print that we received an event
    unless element
        -- take pre 0.10.0 wheel movement and pass it along
        if button == "wd"
          pop.wheelmoved 0, -1
          return true
        elseif button == "wu"
          pop.wheelmoved 0, 1
          return true

        log "mousepressed", x, y, button
        element = pop.screen

    -- have we handled the event?
    handled = false

    -- if it is inside the current element..
    if element.data.draw and (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h)
        -- check its child elements in reverse order, returning if something handles it
        for i = #element.child, 1, -1
            handled = pop.mousepressed x, y, button, element.child[i]
            if handled != false
                return handled

        -- if a child hasn't handled it yet, try to handle it, and set pop.focused
        if element.mousepressed
            handled = element\mousepressed x - element.data.x, y - element.data.y, button
            if handled != false
                pop.focused = element

    -- return whether or not we have handled the event
    return handled



--- Event handler for `love.mousereleased()`.
--- @function mousereleased
--- @tparam integer x The x coordinate of the mouse release.
--- @tparam integer y The y coordinate of the mouse release.
--- @tparam ?string|integer button The mouse button released. (Type varies by
--- LÖVE version.)
--- @tparam Element element[opt] The element to check for event handling (will
--- check its children as well). Defaults to `pop.screen`.
--- @treturn boolean Was a click handled?
--- @treturn boolean Was a mouse release handled?
--- @see Element

pop.mousereleased = (x, y, button, element) ->
    -- we are trying to handle a clicked or mousereleased event
    clickedHandled = false
    mousereleasedHandled = false

    -- if we have an element, and are within its bounds
    if element
        if element.data.draw and (x >= element.data.x) and (x <= element.data.x + element.data.w) and (y >= element.data.y) and (y <= element.data.y + element.data.h)
            -- check its children in reverse for handling a clicked or mousereleased event
            for i = #element.child, 1, -1
                clickedHandled, mousereleasedHandled = pop.mousereleased x, y, button, element.child[i]
                if clickedHandled != false or mousereleasedHandled != false
                    return clickedHandled, mousereleasedHandled

            -- if that doesn't work, we try to handle it ourselves
            if element.clicked
                clickedHandled = element\clicked x - element.data.x, y - element.data.y, button
            if element.mousereleased
                mousereleasedHandled = element\mousereleased x - element.data.x, y - element.data.y, button

            -- if we clicked, we're focused!
            if clickedHandled != false
                pop.focused = element
                --- @todo Figure out how to bring a focused element to the front of view (aka the first element in its parent's children).
                --- (If I do it right here, the for loop above may break! I need to test/figure this out.)
                --NOTE this might cause an error in the above for loop!
                -- basically, move focused element to front of its parent's child
                --element.parent\focusChild element
                --table.insert element.parent, element.parent\removeChild(element),

    -- else, default to pop.screen to begin! (and print that we received an event)
    else
        log "mousereleased", x, y, button
        pop.mousereleased x, y, button, pop.screen

    return clickedHandled, mousereleasedHandled



--- Event handler for `love.wheelmoved()`
--- @function wheelmoved
--- @tparam number x The distance the wheel moved on the x-axis.
--- @tparam number y The distance the wheel moved on the y-axis.
--- @treturn boolean Was the event handled?
pop.wheelmoved = (x, y) ->
    log "wheelmoved", x, y

    if pop.hovered and pop.hovered.wheelmoved
        return pop.hovered\wheelmoved x, y

    return false



--- Event handler for `love.keypressed()`.
--- @function keypressed
--- @tparam string key The key that was pressed.
--- @treturn boolean Was the event handled?

pop.keypressed = (key) ->
    log "keypressed", key

    -- keypressed events must be on visible elements
    element = pop.focused
    if element and element.keypressed and element.data.draw
        return element.keypressed key

    return false



--- Event handler for `love.keyreleased()`.
--- @function keyreleased
--- @tparam string key The key that was released.
--- @treturn boolean Was the event handled?

pop.keyreleased = (key) ->
    log "keyreleased", key

    -- keyreleased events are always called
    element = pop.focused
    if element and element.keyreleased
        return element.keyreleased key

    return false



--- Event handler for `love.textinput()`.
--- @function textinput
--- @tparam string text The text that was typed.
--- @treturn boolean Was the text input handled?

pop.textinput = (text) ->
    log "textinput", text

    -- textinput events must be on visible elements
    element = pop.focused
    if element and element.textinput and element.data.draw
        return element.textinput text

    return false



--- @todo document pop.import

pop.import = (data, parent=pop.screen) ->
    local element
    if type(data) == "string"
        data = loads(data)
        element = pop.create(data.type, parent, data)
    else
        element = pop.elements[data.type](parent, data) --why is it not the same as the other way?
        insert parent.child, element

    for i = 1, #data.child
        pop.import data.child[i], element



--- @todo document pop.export

pop.export = (element=pop.screen) ->
    return dumps(element.data)



--- Draws simple rectangle outlines to debug placement of elements.
--- @function debugDraw
--- @tparam Element element[opt] The element to draw (will draw its children as
--- well). Defaults to `pop.screen`.
--- @see Element

pop.debugDraw = (element=pop.screen) ->
    --@todo Remove element.debugDraw functions.
    graphics.setLineWidth 1
    graphics.setColor 0, 0, 0, 100
    graphics.rectangle "fill", element.data.x, element.data.y, element.data.w, element.data.h
    graphics.setColor 150, 150, 150, 150
    graphics.rectangle "line", element.data.x, element.data.y, element.data.w, element.data.h
    graphics.setColor 200, 200, 200, 255

    if element.debugInfo
        graphics.print "#{element.__class.__name\sub 1, 1} (#{element\debugInfo!})", element.data.x, element.data.y
    else
        graphics.print "#{element.__class.__name\sub 1, 1}", element.data.x, element.data.y

    for i = 1, #element.child
        pop.debugDraw element.child[i]



--- Prints a basic structure of GUI elements with minimal info.
--- @function printElementTree
--- @tparam Element element[opt] The element to start at. Defaults to
--- `pop.screen`.
--- @see Element

pop.printElementTree = (element=pop.screen, depth=0) ->
    --- @todo Write debugInfo things for elements.
    cls = element.__class.__name

    if element.debugInfo
      cls = "#{cls} (#{element\debugInfo!})"

    if depth > 0
        log string.rep("-", depth) .. " #{cls}"
    else
        log cls

    for i = 1, #element.child
        pop.printElementTree element.child[i], depth + 1



-- finally, load is called and pop returned
pop.load!
return pop
