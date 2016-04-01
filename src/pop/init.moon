import filesystem, graphics from love
import insert from table

path = ...

pop = {}

pop.elements = {}
pop.skins = {}

pop.screen = false -- initialized in pop.load()
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

    -- main window (called screen because there will be a window element class)
    pop.screen = pop.create("element", false)\setSize(graphics.getWidth!, graphics.getHeight!)
    print "created \"pop.screen\""

instanceOfElement = (object) ->
    if object.__class
        class = object.__class

        if class.__name == "element"
            return true

        while class.__parent
            class = class.__parent
            if class.__name == "element"
                return true

    return false

-- creates an element with specified parent (parent can be false)
pop.create = (element, parent=pop.screen, ...) ->
    --if parent
    --    print parent.__class, parent.__class.__name, parent.__class.__base, parent.__class.__parent
    --element = pop.elements[element](parent, ...)

    if instanceOfElement parent
        element = pop.elements[element](parent, ...)
    else
        element = pop.elements[element](pop.screen, parent, ...)

    if parent
        insert parent.child, element

    return element

pop.update = (dt, element=pop.screen) ->
    --pop.screen\update dt
    unless element.excludeUpdate
        if element.update
            element\update dt
        for i = 1, #element.child
            pop.update dt, element.child[i]

pop.draw = (element=pop.screen) ->
    --pop.screen\draw!
    unless element.excludeDraw
        if element.draw
            element\draw!
        for i = 1, #element.child
            pop.draw element.child[i]

pop.mousepressed = (x, y, button, element=pop.screen) ->
    if element == pop.screen
        print "mousepressed", x, y, button, element

    handled = false
    if (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h)
        if element.mousepressed
            handled = element\mousepressed x - element.x, y - element.y, button
        if handled
            pop.focused = element
        else
            for i = 1, #element.child
                handled = pop.mousepressed x, y, button, element.child[i]
                if handled
                    pop.focused = element.child[i]
                    break
    return handled

pop.mousereleased = (x, y, button, element=pop.screen) ->
    --[[
    --if element == pop.screen
    --    print "mousereleased", x, y, button, element

    --clickHandled = false
    --mouseReleaseHandled = false

    --if (x >= element.x) and (x <= element.x + element.w) and (y >= element.y) and (y <= element.y + element.h)
    --    if element.mousereleased
    --        mouseReleaseHandled = element\mousereleased x - element.x, y - element.y, button
    --    unless mouseReleaseHandled
    --        for i = 1, #element.child
    --            clickHandled, mouseReleaseHandled = pop.mousereleased x, y, button, element.child[i]
    --            if mouseReleaseHandled
    --                break

    --if element == pop.focused

    --return mouseReleaseHandled
    --]]

    return false -- ugh this sucks

pop.keypressed = (key) ->
    print "keypressed", key
    return false --TODO event handlers return if they have handled the event!

pop.keyreleased = (key) ->
    print "keyreleased", key
    return false --TODO event handlers return if they have handled the event!

pop.textinput = (text) ->
    print "textinput", text
    return false --TODO event handlers return if they have handled the event!

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

pop.load!

return pop
