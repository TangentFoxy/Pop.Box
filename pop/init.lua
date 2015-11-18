local pop = {}
local path = ... -- this only works as long as the require() does't specify init.lua..which it shouldn't

-- elements are local
local box = require(path .. ".elements.box")
local text = require(path .. ".elements.text")

-- style defines how elements are drawn
pop.style = require(path .. ".skins.clear")

-- everything has one parent element (initialized at the end)
pop.parentElement = false

function pop.create(elementType, parent, ...)
    if not parent then
        parent = pop.parentElement
    end

    local newElement

    if elementType == "box" then
        newElement = box(pop, parent, ...)
    elseif elementType == "text" then
        newElement = text(pop, parent, ...)
    else
        error("Invalid element type: " .. elementType)
    end

    return newElement
end

-- pretty wrappers to call pop.element() instead of pop.create("element")
pop.box = function() return pop.create("box", ...) end
pop.text = function() return pop.create("text", ...) end

function pop.draw(element)
    if not element then
        element = pop.parentElement
    end

    for _, childElements in pairs(element.child) do
        --pop.draw(childElements, element.x, element.y)
        pop.draw(childElements)
    end

    element:draw()
end

-- TODO decide if we should track mouse movement

function pop.mousepressed(button, x, y)
    --
end

function pop.mousereleased(button, x, y)
    --
end

-- initialize the top element
pop.parentElement = box(pop, nil)     -- nil because it has no parent
--pop.parentElement:setVisible(false) -- uneeded since its clear...

return pop
