import filesystem, graphics from love
import insert from table

path = ...

class Pop
    new: =>
        @elements = {}
        @window = {child: {}} --TODO eliminate this crap
        --@focused = @window --TODO redo better

        elements = filesystem.getDirectoryItems "#{path}/elements"
        for i in elements
            name = elements[i]\sub 1, -5
            @elements[name] = require "#{path}/elements/#{name}"
            print "loaded element: #{name}"

            if not @name
                @name = (...) -> return @create(name, ...)
                print "wrapped created: #{name}()"

        @window = @create("element")\setSize(graphics.getWidth!, graphics.getHeight!)
        print "created window"

    create: (elementType, parent=@window, ...) =>
        newElement = @elements[elementType](@, parent, ...)
        insert parent.child, newElement
        return newElement

    update: (dt, element=@window) =>
        if not element.excludeUpdating
            if element.update
                element\update dt

            for i in element.child
                @update dt, element.child[i]

    draw: (element=@window) =>
        if not element.excludeRendering
            if element.draw
                element\draw

            for i in element.child
                @draw element.child[i]

    mousepressed: (button, x, y, element) =>
        error "Unimplemented."

    mousereleased: (button, x, y, element) =>
        error "Unimplemented."

    keypressed: (key) =>
        error "Unimplemented."

    keyreleased: (key) =>
        error "Unimplemented."

    textinput: (text) =>
        error "Unimplemented."

    skin: (element, skin, apply_to_children=false) =>
        element.margin = skin.margin

        if element.background
            element.background = skin.background
        if element.color
            element.color = skin.color
        if element.font
            element.font = skin.font

        if not apply_to_children
            for i in element.child
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

        for i in element.child
            @debugDraw element.child[i]
