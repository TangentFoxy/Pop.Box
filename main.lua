local pop = require("")
local debug = false
love.load = function()
  pop.text("Hello World!"):align("center", "center")
  local centerBox = pop.box({
    w = 200,
    h = 200
  }, {
    255,
    255,
    0,
    120
  }):align("center", "center")
  pop.box(centerBox, {
    w = 10,
    h = 20
  }):align("left", "top")
  pop.box(centerBox, {
    w = 30,
    h = 30
  }):align("center", "top")
  pop.box(centerBox, {
    w = 5,
    h = 40
  }):align("left", "center")
  pop.box(centerBox, {
    w = 50,
    h = 50
  }):align("right", "center")
  pop.box(centerBox):align("left", "bottom"):setSize(5, 5)
  pop.box(centerBox, {
    w = 25,
    h = 10
  }):align("center", "bottom")
  pop.text(centerBox, "Align me!"):align("right", "top")
  pop.window(centerBox):align("right", "bottom")
  pop.box(centerBox, {
    padding = 5,
    w = 10,
    h = 20,
    background = {
      0,
      0,
      255,
      100
    }
  }):align("left", "top")
  pop.box(centerBox, {
    padding = 5,
    w = 30,
    h = 30,
    background = {
      0,
      0,
      255,
      100
    }
  }):align("center", "top")
  pop.box(centerBox, {
    padding = 5,
    w = 5,
    h = 40,
    background = {
      0,
      0,
      255,
      100
    }
  }):align("left", "center")
  pop.box(centerBox, {
    padding = 5,
    w = 50,
    h = 50,
    background = {
      0,
      0,
      255,
      100
    }
  }):align("right", "center")
  pop.text(centerBox, {
    padding = 5,
    color = {
      0,
      0,
      255,
      100
    }
  }, "Text!"):align("left", "bottom")
  pop.box(centerBox, {
    padding = 5,
    w = 25,
    h = 10,
    background = {
      0,
      0,
      255,
      100
    }
  }):align("center", "bottom")
  pop.text(centerBox, {
    padding = 5,
    color = {
      0,
      0,
      255,
      100
    }
  }, "Align me!"):align("right", "top")
  return pop.window(centerBox, {
    padding = 5,
    titleColor = {
      0,
      0,
      0,
      150
    },
    titleBackground = {
      0,
      0,
      255,
      100
    },
    windowBackground = {
      200,
      200,
      255,
      100
    }
  }):align("right", "bottom")
end
love.draw = function()
  pop.draw()
  if debug then
    return pop.debugDraw()
  end
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  elseif key == "d" then
    debug = not debug
  end
end
