local pop = require "pop"

function love.load()
    local align = pop.box():align("center", "center"):setSize(200, 200)
    pop.box(align):align("left", "top"):setSize(75, 10):setColor(255, 0, 255, 255)
    pop.box(align):align("center", "top"):setColor(100, 100, 100)
    pop.box(align, {0, 255, 0, 255}):setSize(20, 5):align("right", "top")
    pop.box(align):align("left", "center"):setColor(0, 0, 255)
    pop.box(align):align("center", "center"):setSize(90, 90):setColor(255, 255, 255)
    pop.box(align):align("right", "center"):setColor(255, 0, 0)
    pop.box(align):align("left", "bottom"):setColor(0, 255, 0)
    pop.box(align):align("center", "bottom"):setColor(255, 255, 0)
    pop.box(align):align("right", "bottom"):setColor(0, 255, 255)
    pop.box(nil, {255, 0, 0, 255}):align("left", "top"):setSize(50, 50)
    pop.text(nil, "Hello World!"):align("center"):setText("Hey, I've been modified!")
end

function love.update(dt)
    pop.update(dt)
end

function love.draw()
    pop.draw()
end

function love.textinput(text)
    pop.textinput(text)
end

function love.mousepressed(button, x, y)
    pop.mousepressed(button, x, y)
end

function love.mousereleased(button, x, y)
    pop.mousereleased(button, x, y)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    else
        pop.keypressed(key)
    end
end

function love.keyreleased(key)
    pop.keyreleased(key)
end
