local pop
import graphics from love

element = require "#{(...)\sub 1, -10}/element"

class scrollbox extends element
  load: (pop_lib) ->
    pop = pop_lib

  new: (@parent, @data={}) =>
    super @parent, @data

    @data.type = "scrollbox" if @data.type == "element"
    @data.color = {255, 255, 255, 255}
    @data.background = {0, 0, 0, 255}

  draw: =>
    graphics.setColor @data.background
    graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h

    --TODO do stuff to set up for drawing
    for i=1, #@data.child
      pop.draw @data.child[i]
    --TODO undo for regular drawing
    --TODO return something to cancel drawing children

    return @

  setColor: (r, g, b, a=255) =>
    if "table" == type r
      @data.color = r
    else
      @data.color = r, g, b, a

    return @

  setBackground: (r, g, b, a=255) =>
    if "table" == type r
      @data.background = r
    else
      @data.background = r, g, b, a

    return @
