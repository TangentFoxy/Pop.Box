import filesystem, graphics from love
import insert from table

path = ...

pop = {}

pop.elements = {}
pop.window = {child: {}} --placeholder to allow window creation without specialized code
--pop.focused = false

pop.load = ->
    elements = filesystem.getDirectoryItems "#{path}/elements"
    for i = 1, #elements
        name = elements[i]\sub 1, -5
        pop.elements[name] = require "#{path}/elements/#{name}"
        print "loaded element: #{name}"

        if not pop[name]
            pop[name] = (...) -> return pop.create(name, ...)
            print "wrapper created: #{name}()"

    pop.window = pop.create("element")\setSize(graphics.getWidth!, graphics.getHeight!)
    --pop.window.parent = pop.window --may be dangerous? infinite loop looking for the window?
    --pop.window.parent = false --may be dangerous? attempting to index a boolean?
    print "created window"

pop.create = (elementType, parent=pop.window, ...) ->
    newElement = pop.elements[elementType](parent, ...)
    insert parent.child, newElement
    return newElement

pop.update = (dt, element=pop.window) ->
    if not element.excludeUpdating
        if element.update
            element\update dt

        for i = 1, #element.child
            pop.update dt, element.child[i]

pop.draw = (element=pop.window) ->
    if not element.excludeRendering
        if element.draw
            element\draw

        for i = 1, #element.child
            pop.draw element.child

pop.mousepressed = (button, x, y, element=pop.window) ->
    -- if within bounds, check children
    --  if not handled, check if we can handle it
    --   abort with success if handled
    if (x >= element.x) and (x <= (element.x + element.w))
        if (y >= element.y) and (y <= (element.y + element.h))
            for i = 1, #element.child
                if pop.mousepressed button, x, y, element.child[i]
                    return true

            if element.mousepressed
                return element\mousepressed button, x - element.x, y - element.y
            else
                return false

--TODO multiple return values, mousereleased first, click second
pop.mousereleased = (button, x, y, element=pop.window) ->
    -- same as mousepressed, except a click can be fired as well

pop.keypressed = (key) ->
    print "pop.keypressed() is unimplemented."

pop.keyreleased = (key) ->
    print "pop.keyreleased() is unimplemented."

pop.textinput = (text) ->
    print "pop.textinput() is unimplemented."

pop.skin = (element, skin, apply_to_children=true) ->
    element.margin = skin.margin

    if element.background
        element.background = skin.background
    if element.color
        element.color = skin.color
    if element.font
        element.font = skin.font

    if apply_to_children
        for i = 1, #element.child
            pop.skin element.child[i], skin

pop.debugDraw = (element=pop.window) ->
    if element.debugDraw
        element\debugDraw!
    else
        graphics.setLineWidth 1
        graphics.setColor 0, 0, 0, 100
        graphics.rectangle "fill", element.x, element.y, element.w, element.h
        graphics.setColor 150, 150, 150, 150
        graphics.rectangle "line", element.x, element.y, element.w, element.h
        graphics.setColor 200, 200, 200, 255
        graphics.print ".", element.x, element.y

    for i = 1, #element.child
        pop.debugDraw element.child[i]

pop.load!

return pop
