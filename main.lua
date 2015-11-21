local pop = require "pop" --TODO tell user that pop must be required with SLASHES

function love.load()
    local box = pop.box() -- returns the box element
    -- or pop.create("box") (this is what is actually called when you call pop.box())

    --TODO uncomment these once text is implemented!
    --local text = pop.text(box) -- box will become the parent element of text
    --text:setText("Hello and welcome to an example of Pop.Box, a very small shitty example.")
end

function love.draw()
    pop.draw()
end

function love.mousepressed(button, x, y)
    pop.mousepressed(button, x, y)
end

function love.mousereleased(button, x, y)
    pop.mousereleased(button, x, y)
end

function love.keypressed(key)
    if not pop.keypressed(key, unicode) then
        if key == "escape" then
            love.event.quit()
        end
    end
end

function love.keyreleased(key)
    pop.keyreleased(key)
end
