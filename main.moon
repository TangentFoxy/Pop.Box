--- A demo program for Pop.Box.
--- @copyright Paul Liverman III (2016)
--- @license The MIT License (MIT)

pop = require ""

pop.text("Hello World!")\align "center", "center"

--- @todo finish writing callbacks!

love.draw = ->
    pop.draw!
    --pop.debugDraw!

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit!



-- NOTE TEMPORARY
--inspect = require "lib/inspect/inspect"
--print inspect pop



return --this is to prevent default returning of last statement
