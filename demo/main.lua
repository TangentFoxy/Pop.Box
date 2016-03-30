local lg = love.graphics
local pop

function love.load()
    pop = require "pop"
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

    c:move(100)

    w2 = pop.window(nil, "Window")
    w2:move(100, 100)
    w2:setWidth(500)
    w2:move(-50, 80)
    w2:setHeight(500)
    w2:move(0, -175)
    w2.child[2]:align("center")
    --w2:align("center")
    --w2:setAlignment("center"):align("center")

    --w2.child[1]:setBackground {100, 100, 100, 255}
    --w2.child[3]:setBackground {160, 140, 40, 255}

    --TODO make rounding to nearest pixel DEFAULT BEHAVIOR
    --TODO make debugdraw better
end

function love.update(dt)
    pop.update(dt)
end

function love.draw()
    pop.draw()
    --pop.debugDraw()
    --w2:debugDraw()
end

function love.mousepressed(x, y, button)
    pop.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    pop.mousereleased(x, y, button)
end

function love.keypressed(key)
    local handled = pop.keypressed(key)

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
