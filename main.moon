--- A demo program for Pop.Box.
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

import graphics from love

pop = require ""
debug = false

love.load = ->
    old_method = ->
        pop.text("Hello World!")\align "center", "center"
        testWindow = pop.window({windowBackground: {200, 200, 200}, closeable: true, maximizeable: true, minimizeable: true}, "Testing Window")\move(20, 20)\setSize(200, 100)\align "right", "top"
        print testWindow.window_area

        pop.window({maximizeable: true}, "Test Window #2")\align "center", "bottom"

        -- alignment testing
        centerBox = pop.box({w: 200, h: 200}, {255, 255, 0, 120})\align "center", "center"
        pop.box(centerBox, {w: 10, h: 20})\align "left", "top"
        pop.box(centerBox, {w: 30, h: 30})\align "center", "top"
        pop.box(centerBox, {w: 5, h: 40})\align "left", "center"
        pop.box(centerBox, {w: 50, h: 50})\align "right", "center"
        pop.box(centerBox)\align("left", "bottom")\setSize 5, 5
        pop.box(centerBox, {w: 25, h: 10})\align "center", "bottom"
        pop.text(centerBox, "Align me!")\align "right", "top"
        pop.window(centerBox, {closeable: true})\align "right", "bottom"

        centerBox\setPadding 5

        pop.box(centerBox, {w: 10, h: 20, background: {0, 0, 255, 100}})\align "left", "top"
        pop.box(centerBox, {w: 30, h: 30, background: {0, 0, 255, 100}})\align "center", "top"
        pop.box(centerBox, {w: 5, h: 40, background: {0, 0, 255, 100}})\align "left", "center"
        pop.box(centerBox, {w: 50, h: 50, background: {0, 0, 255, 100}})\align "right", "center"
        pop.text(centerBox, {color: {0, 0, 255, 100}}, "Text!")\align("left", "bottom")--\setSize 5, 5
        pop.box(centerBox, {w: 25, h: 10, background: {0, 0, 255, 100}})\align "center", "bottom"
        pop.text(centerBox, {color: {0, 0, 255, 100}}, "Align me!")\align "right", "top"
        pop.window(centerBox, {titleColor: {0, 0, 0, 150}, titleBackground: {0, 0, 255, 100}, windowBackground: {200, 200, 255, 100}})\align "right", "bottom"
        pop.window(centerBox, {containMethod: "title", w: 125}, "Title can't leave")
        pop.window(centerBox, {containMethod: "body", w: 125}, "Body can't leave")

    new_method = ->
        partsGrid = pop.dynamicGrid!
        pop.window({w: graphics.getWidth!/2, h: graphics.getHeight!, titleBar: false})\add({
            pop.box({h: 17}) -- temporary height
            pop.scrollbox()\add(
                partsGrid
            )
            pop.grid()\add({
                pop.button()
                pop.button()
                pop.button()
            })
        })

    old_method!
    --new_method!

love.update = (dt) ->
    pop.update dt

love.draw = ->
    pop.draw!
    pop.debugDraw! if debug

love.mousemoved = (x, y, dx, dy) ->
    pop.mousemoved x, y, dx, dy

love.mousepressed = (x, y, button) ->
    pop.mousepressed x, y, button

love.mousereleased = (x, y, button) ->
    pop.mousereleased x, y, button

love.wheelmoved = (x, y) ->
    pop.wheelmoved x, y

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit!
    elseif key == "d"
        debug = not debug
    elseif key == "t"
        print("pop.focused", pop.focused)

love.keyreleased = (key) ->
    pop.keyreleased key

love.textinput = (text) ->
    pop.textinput text



-- NOTE TEMPORARY
--inspect = require "lib/inspect/inspect"
--print inspect pop



return --this is to prevent default returning of last statement
