local lg = love.graphics
local pop, inspect

local debugDraw = false
local videoFile = lg.newVideo("test.ogv") -- so we can loop playback

function love.load()
    print(love.getVersion())

    inspect = require "debug-lib/inspect"
    pop = require "pop"
    ---[[
    local c = pop.box():align("center", "center"):setSize(300, 300)
    pop.box(c, {255, 0, 0, 255}):setSize(100, 50)
    pop.box(c, {0, 255, 0, 255}):align("center"):setSize(100, 100)
    pop.box(c, {0, 0, 255, 255}):align("right"):setSize(50, 100)
    pop.box(c, {100, 100, 100, 255}):align("center", "center"):setSize(500, 100)
    pop.box(c):align("center"):setSize(50, 500):move(0, -100)
    pop.box(c, {255, 255, 0, 255}):align(false, "bottom"):setSize(100, 100)
    pop.box(c, {255, 150, 0, 255}):align("center", "bottom"):setSize(100, 50)
    pop.box(c, {0, 255, 255}):align("right", "bottom"):setSize(50, 100):move(-50)
    pop.text(nil, "Here's some test text\n(with newlines)\nin the top left corner!")
    pop.text(nil, "Here's some test text in the bottom right corner!"):align("right", "bottom")
    pop.skin(pop.text("Here's easier-to-code test text in the center!"):align("center", "center", true)) -- 'true' means align to pixel!
    w = pop.box(nil, {255, 255, 255, 255}):align(false, "bottom"):setSize(150, 150)
    b = pop.box(w, {0, 0, 0, 255}):setMargin(5):setSize(100, 100)
    --]]

    --c:move(100)
    pop.box({255, 0, 0, 255}):position(50, 500) -- testing streamlined_get_set extension & optional parents
    --b:margin(2) -- testing streamlined_get_set extension
    b:fill() -- testing fill!

    w2 = pop.window(nil, "Window")
    w2:move(100, 100)
    w2:setWidth(500)
    w2:move(-50, 80)
    w2:setHeight(500)
    w2:move(0, -175)
    w2.title:align("center")
    w2:position(0, 0)
    w2:size(200, 120):position(90, 70)
    w2:setClose(false)
    local t2 = pop.text("Click here to toggle close\nbutton on this window."):setMargin(10):setColor(0,0,0)
    t2.clicked = function()
        print("CALLED") --NOTE not working!
        w2:setClose(not w2:hasClose())
        return true
    end
    w2:addChild(t2)

    local test = lg.newImage("test.png")
    G = pop.element():align("right"):move(-2, 2)
    a = pop.box(G, test):align("right")
    b = pop.box(G, test):align("right"):move(-25):setWidth(40)
    c = pop.box(G, test):align("right"):move(0, 25):setHeight(40)

    print(a.horizontal, a.vertical)
    print(b.horizontal, b.vertical)
    print(c.horizontal, c.vertical)

    local window = pop.window():align("center", "center"):setTitle("Welcome! This title is far too big!")
    --window:addChild(pop.text("Welcome to Pop.Box()!"))

    pop.window():setClose(false):setClose(true)

    local video = pop.box():align("right", "bottom"):setBackground(videoFile):setSize(320/2, 240/2):move(-20, -20)
    videoFile:play()

    --TODO make debugDraw better
end

function love.update(dt)
    pop.update(dt)

    if not videoFile:isPlaying() then
        videoFile:rewind()
    end
end

function love.draw()
    pop.draw()

    if debugDraw then
        pop.debugDraw()
        --w2:debugDraw()
    end
end

function love.mousemoved(x, y, dx, dy)
    pop.mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button)
    pop.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    pop.mousereleased(x, y, button)
end

function love.keypressed(key)
    local handled = pop.keypressed(key)

    if (key == "d") and (not handled) then
        debugDraw = not debugDraw
    end

    if (key == "escape") and (not handled) then
        love.event.quit()
    end
end

function love.keyreleased(key)
    pop.keyreleased(key)
end

function love.textinput(text)
    pop.textinput(text)
end
