local lg = love.graphics
local pop, parts

-- pretend parts has been defined

function love.load()
    pop = require "lib.pop"
    local width4 = lg.getWidth()/4
    local height2 = lg.getHeight()/2
    local PartList = pop.scrollbox():setSize(width4, height2)--:setSizeControl(true) --defaults to true
    local PartInfo = pop.scrollbox():setSize(width4, height2):move(nil, height2)
    local CraftInfo = pop.box():setSize(width4, height2):move(lg.getWidth()*3/4)
    local columns = math.floor(PartList:getWidth()/128)
    local rows = math.floor(#parts/columns)
    local grid = pop.grid(PartList, columns, rows)
    for i = 1, #parts do
        -- pretend that parts.gui is a box designed to fix in here properly
        grid:add(parts[i].gui) -- pretend by default, adding something to a grid like this adds it to first available spot
        -- also, grids auto-resize their children
    end
    PartList:add(grid) -- BULLSHIT ?!
end

-- parts.gui is something like this:

gui = pop.box(newImage()) -- assumes a box can take 'userdata' as first arg and know it is an image
gui.clicked = function(x, y, button)
    -- don't care about x/y
    if button == "l" then --left
        selected = gui.partReference -- or something
    elseif button == "r" then --right
        displayPartInfo() -- something happens to display it in the proper spot
    end
end
