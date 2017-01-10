local pop = require("")
pop.text("Hello World!"):align("center", "center")
love.draw = function()
  return pop.draw()
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end
