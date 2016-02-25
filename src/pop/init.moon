import filesystem, graphics from love
import insert from table

path = ...

class Pop
    new: =>
        @elements = {}
        @window = {child: {}}
        --@focused = @window --TODO redo better

        elements = filesystem.getDirectoryItems "#{path}/elements"
        for i = 1, #elements
            name = elements[i]\sub 1, -5
            @elements[name] = require "#{path}/elements/#{name}"
            print "loaded element: #{name}"

            if not @[name]
                @[name] = (...) => return @create(name, ...)
                print "wrapper created: #{name}()"

        @window = @create("element", @window)\setSize(graphics.getWidth!, graphics.getHeight!)
        print "created window"
        --@window.parent = @window
        --@window.parent = false

    create: (elementType, parent=@window, ...) =>
        newElement = @elements[elementType](parent, ...)
        insert parent.child, newElement
        return newElement

    update: (dt, element=@window) =>
        if not element.excludeUpdating
            if element.update
                element\update dt

            for i = 1, #element.child
                @update dt, element.child[i]

    draw: (element=@window) =>
        if not element.excludeRendering
            if element.draw
                element\draw

            for i = 1, #element.child
                @draw element.child[i]

    mousepressed: (button, x, y, element=@window) =>
        -- if within bounds of element, check its children
        --  if not handled by child, check if it can handle it
        --   abort loop with success if handled
        if (x >= element.x) and (x <= (element.x + element.w))
            if (y >= element.y) and (y <= (element.y + element.h))
                for i = 1, #element.child
                    if @mousepressed button, x, y, element.child[i]
                        return true

                if element.mousepressed
                    return element\mousepressed button, x - element.x, y - element.y
                else
                    return false

    --TODO rewrite for multiple return values, mousereleased is the first val, click is the second!
    mousereleased: (button, x, y, element=@window) =>
        -- same as mousepressed, except an additional click is fired
        --  (TODO fix, so you have to start and end the click on the same element)
        if (x >= element.x) and (x <= (element.x + element.w))
            if (y >= element.y) and (y <= (element.y + element.h))
                for i = 1, #element.child
                    if @mousereleased button, x, y, element.child[i]
                        return true

                if element.mousereleased
                    return element\mousereleased button, x - element.x, y - element.y
                else
                    return false

    keypressed: (key) =>
        error "Unimplemented."

    keyreleased: (key) =>
        error "Unimplemented."

    textinput: (text) =>
        error "Unimplemented."

    skin: (element, skin, apply_to_children=true) =>
        element.margin = skin.margin

        if element.background
            element.background = skin.background
        if element.color
            element.color = skin.color
        if element.font
            element.font = skin.font

        if apply_to_children
            for i = 1, #element.child
                @skin element.child[i], skin

    debugDraw: (element=@window) =>
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
            @debugDraw element.child[i]
