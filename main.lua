local pop = require "pop"

function love.load()
    --pop.box() -- returns the box element
    -- or pop.create("box") (this is what is actually called when you call pop.box())
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
