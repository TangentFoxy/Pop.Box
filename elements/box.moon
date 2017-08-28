--- A generic box, drawn with specified color or an image.
--- @classmod box
--- @copyright Paul Liverman III (2017)
--- @license The MIT License (MIT)
--- @todo Make 9-slices available!
--- @todo Correct documentation on all elements

import graphics from love

element = require "#{(...)\sub 1, -4}/element"

class box extends element
  --- Constructor expects nothing, or a data table describing it.
  new: (@parent, @data={}, background={255, 255, 255, 255}) =>
    -- assume a data object with four values is actually the background
    if #@data == 4
      background = @data
      @data = nil

    super @parent, @data

    @data.type = "box" if @data.type == "element"
    @data.background = background unless @data.background

  draw: =>
    if "table" == type @data.background
      graphics.setColor @data.background
      graphics.rectangle "fill", @data.x, @data.y, @data.w, @data.h
    else
      w, h = @data.background\getDimensions!
      w = @data.w / w
      h = @data.h / h
      graphics.setColor 255, 255, 255, 255
      graphics.draw @data.background, @data.x, @data.y, 0, w, h

    return @

  setBackground: (background) =>
    if background
      @data.background = background
    else
      error "Background must be a table representing a color, or a drawable object."
    return @

  getBackground: =>
    return @data.background

  setColor: (r, g, b, a=255) =>
    if "table" == type r
      @data.background = r
    else
      @data.background = {r, g, b, a}

    return @

  getColor: =>
    if "table" == type @data.background
      return unpack @data.background
    else
      return 255, 255, 255, 255   -- if it is drawable, it is drawn with a white color
