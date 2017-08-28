import graphics from love

element = require "#{(...)\sub 1, -11}/element"

recursiveDraw = (children, x, y) ->
  for i = 1, #children
    child = children[i]
    local drawChildren
    if child.draw
      child.data.x -= x
      child.data.y -= y
      drawChildren = child\draw!
      child.data.x += x
      child.data.y += y
    if drawChildren != false
      recursiveDraw child.child, x, y

local canvasDraw
major, minor = love.getVersion!

if major == 0 and minor == 10
  canvasDraw = (canvas, x, y) ->
    graphics.draw canvas, x, y
else
  canvasDraw = (canvas, x, y) ->
    mode, alpha = graphics.getBlendMode!
    graphics.setBlendMode "alpha", "premultiplied"
    graphics.draw canvas, x, y
    graphics.setBlendMode mode, alpha

-- canvasDraw = (canvas, x, y) ->
--   graphics.draw canvas, x, y

class clipRegion extends element
  new: (@parent, @data={}) =>
    super @parent, @data

    @data.type = "clipRegion" if @data.type == "element"
    @canvas = graphics.newCanvas @data.w, @data.h

  draw: =>
    graphics.setCanvas @canvas
    graphics.clear!
    recursiveDraw @child, @data.x, @data.y
    graphics.setCanvas!
    graphics.setColor 255, 255, 255, 255
    canvasDraw @canvas, @data.x, @data.y
    return false
