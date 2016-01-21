local pop = require "pop"

function love.load()
    pop.setSkin("blackonwhite")
    local align = pop.box():align("center", "center"):setSize(100, 100):setSkin("blackonwhite")
    --print(align.skin)
end

function love.update(dt)
    pop.update(dt)
end

function love.draw()
    pop.draw()
    love.graphics.setColor(255, 255, 255, 255)
    --love.graphics.rectangle("fill", 0, 0, 100, 100)
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
