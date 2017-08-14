local class = require "Class"

local Car = class("Car")

function Car:__init(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Car:print() -- this will be broken
  print("I'm a car, at ("..self.x..","..self.y..")")
end
