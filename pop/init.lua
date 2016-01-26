local lf = love.filesystem
local lg = love.graphics
local path = ...

local pop = {}
pop.elementClasses = {}
--pop.elements = {}
pop.window = {child = {}} --top level element, defined in pop.load()
pop.focused = pop.window  --defaults to top level

function pop.load()
    -- load element classes
    local elementList = lf.getDirectoryItems(path .. "/elements")

    for i=1, #elementList do
        local name = elementList[i]:sub(1, -5)
        pop.elementClasses[name] = require(path .. "/elements/" .. name)
        print("loaded \"" .. name .. "\" element")

        -- wrapper to be able to call pop.element() to create elements
        if not pop[name] then
            pop[name] = function(...) return pop.create(name, ...) end
            print("wrapper: pop." .. name .. "() created")
        end
    end

    -- set top element
    pop.window = pop.create("element"):setSize(lg.getWidth(), lg.getHeight())
    print("created pop.window")
end

function pop.create(elementType, parent, ...)
    if not parent then
        parent = pop.window
    end

    local newElement = pop.elementClasses[elementType](pop, parent, ...)
    table.insert(parent.child, newElement) --NOTE pop.window is its own parent?

    return newElement
end

function pop.update(dt, element)
    if not element then
        element = pop.window
    end

    if not element.excludeUpdating then
        if element.update then
            element:update(dt)
        end

        for i=1,#element.child do
            pop.update(dt, element.child[i])
        end
    end
end

function pop.draw(element)
    if not element then
        element = pop.window
    end

    if not element.excludeRendering then
        if element.draw then
            element:draw()
        end

        for i=1,#element.child do
            pop.draw(element.child[i])
        end
    end
end

function pop.mousepressed(button, x, y, element)
    if not element then
        element = pop.window

        if (x < element.x) or (y < element.y) or
        (x > (element.x + element.w)) or (y > (element.y + element.h)) then
            return
        end
    end

    local handled = false
    for i=1,#element.child do
        if (x >= element.x) and (y >= element.y) and
        (x <= (element.x + element.w)) and (y <= (element.y + element.h)) then
            handled = pop.mousepressed(button, x, y, element.child[i])
        end
    end

    if (not handled) and element.mousepressed then
        element:mousepressed(button, x - element.x, y - element.y)
        pop.focused = element
    end

    return handled
end

function pop.mousereleased(button, x, y, element)
    if not element then
        element = pop.window

        if (x < element.x) or (y < element.y) or
        (x > (element.x + element.w)) or (y > (element.y + element.h)) then
            return
        end
    end

    local handled = false
    for i=1,#element.child do
        if (x >= element.x) and (y >= element.y) and
        (x <= (element.x + element.w)) and (y <= (element.y + element.h)) then
            handled = pop.mousereleased(button, x, y, element.child[i])
        end
    end

    if not handled then
        if element.mousereleased then
            element:mousereleased(button, x - element.x, y - element.y)
            handled = true
        end
        if element.clicked then
            element:clicked(button, x - element.x, y - element.y)
            handled = true
        end
    end

    return handled
end

function pop.keypressed(key)
    --TODO no idea what to do with this
end

function pop.keyreleased(key)
    --TODO no idea what to do with this
end

function pop.textinput(text)
    --TODO something useful will happen here
end

function pop.skin(element, skin, stop)
    if element.background then
        element.background = skin.background
    end
    if element.color then
        element.color = skin.color
    end
    if element.font then
        element.font = skin.font
    end

    if not stop then
        for i=1,#element.child do
            pop.skin(element.child[i], skin)
        end
    end
end

function pop.debugDraw(element)
    if not element then
        element = pop.window
    end

    if element.debugDraw then
        element:debugDraw()
    else
        lg.setLineWidth(1)
        lg.setColor(0, 0, 0, 100)
        lg.rectangle("fill", self.x, self.y, self.w, self.h)
        lg.setColor(150, 150, 150, 150)
        lg.rectangle("line", self.x, self.y, self.w, self.h)
        lg.setColor(200, 200, 200, 255)
        lg.print(".", self.x, self.y)
    end

    for i=1,#element.child do
        pop.debugDraw(element.child[i])
    end
end

pop.load()

return pop
