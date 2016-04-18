local lg = love.graphics
local pop, inspect

local debugDraw = false

function love.load()
    pop = require "pop"

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
        w2:setClose(not w2:hasClose())
        return true
    end
    w2:addChild(t2)
end

function love.update(dt)
    pop.update(dt)
end

function love.draw()
    pop.draw()

    if debugDraw then
        pop.debugDraw()
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

    if (key == "w") and (not handled) then
        local w = pop.window()
        w.title:align("center")
    end

    if (key == "p") and (not handled) then
        pop.printElementStack()
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
