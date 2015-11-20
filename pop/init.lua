local lf = love.filesystem
local lg = love.graphics

local pop = {}
local path = ... --NOTE Pop.Box must be required as its directory name (w SLASHES)!

-- elements are local
--TODO require these how skins are required
local box = require(path .. ".elements.box")
local text = require(path .. ".elements.text")

-- skins define how elements are drawn
pop.skins = {}
local skins = lf.getDirectoryItems(path .. "/skins") --NOTE Pop.Box must be required with SLASHES!
for _, v in ipairs(skins) do
    local name = v:sub(1,-5)
    pop.skins[name] = require(path .. "/skins/" .. name)
    pop.skins[name].name = name
end
pop.currentSkin = "clearspace" --default skin

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
pop.box = function(...) return pop.create("box", ...) end
pop.text = function(...) return pop.create("text", ...) end

function pop.draw(element)
    if not element then
        element = pop.parentElement
    end

    element:draw()

    for _, childElement in pairs(element.child) do
        --pop.draw(childElement, element.x, element.y)
        pop.draw(childElement)
    end
end

-- TODO decide if we should track mouse movement

function pop.onMousePress(button, x, y) end
function pop.onMouseRelease(button, x, y) end

function pop.mousepressed(button, x, y)
    --TODO find which element it belongs to and if that element has a callback set,
    -- if it does, use that, else, use the global callback (defined above..as nil)
end

function pop.mousereleased(button, x, y)
    --TODO find which element it belongs to and if that element has a callback set,
    -- if it does, use that, else, use the global callback (defined above..as nil)
end

-- initialize the top element
pop.parentElement = box(pop, {child={}})     -- dummy object because it has no parent
--pop.parentElement:setSizeControl("specified") -- make it not try to update itself (TODO or based on outro, and custom code to check top parent against screen size)
--pop.parentElement:setSize(lg.getWidth(), lg.getHeight()) -- fill window size
--pop.parentElement:setVisible(false) -- uneeded since its clear...

return pop
