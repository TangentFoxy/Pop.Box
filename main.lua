local pop = require "pop"

local lg = love.graphics

local visualTestsShown = false
local testsRun = false
local debugDrawEnabled = false

function love.load()
    pop.text(nil, "Press \"s\" to show objects for visual testing/demo.\nPress \"t\" to run tests.\nPress \"d\" to toggle debug draw."):move(2, 2)
    --TODO correct the fact that the size is wrong here! (height doesn't take into account \n)
    --NOTE width? Is width calculated correctly when \n's exist? TEST THIS (also test tabs)
end

function love.update(dt)
    pop.update(dt)
end

function love.draw()
    pop.draw()

    if debugDrawEnabled then
        pop.debugDraw()
    end
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
        if (key == "s") and (not visualTestsShown) then
            -- old visual tests
            local align = pop.box():align("center", "center"):setSize(200, 200)
            pop.box(align):align("left", "top"):setSize(75, 10):setColor(255, 0, 255, 255)
            pop.box(align):align("center", "top"):setColor(100, 100, 100)
            pop.box(align, {0, 255, 0, 255}):setSize(20, 5):align("right", "top")
            pop.box(align):align("left", "center"):setColor(0, 0, 255)
            pop.box(align):align("center", "center"):setSize(90, 90):setColor(255, 255, 255)
            pop.box(align):align("right", "center"):setColor(255, 0, 0)
            pop.box(align):align("left", "bottom"):setColor(0, 255, 0):setSize(nil, 40)
            pop.box(align):align("center", "bottom"):setColor(255, 255, 0)
            pop.box(align):align("right", "bottom"):setColor(0, 255, 255):setSize(40, 40)
            --pop.box(nil, {255, 0, 0, 255}):align("left", "top"):setSize(50, 50) --TODO adjust z-height of elements
            pop.text(nil, "Hello World!"):align("center"):setText("Hey, I've been modified!")--:move(0, 18)
            pop.text(nil, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()-=_+[]{}\\|:;\"',./<>?`~"):align("center", "bottom")

            visualTestsShown = true
        elseif (key == "t") and (not testsRun) then
            require "test"
        elseif key == "d" then
            debugDrawEnabled = not debugDrawEnabled
        end

        pop.keypressed(key)
    end
end

function love.keyreleased(key)
    pop.keyreleased(key)
end
