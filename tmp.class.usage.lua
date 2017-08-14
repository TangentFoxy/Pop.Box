local class = require "class"

local Car, CarBase = class("Car")

function Car:__init(x, y)
  self.x = x or 0
  self.y = y or 0
end

function CarBase:print() -- this will be correct
  print("I'm a car, at ("..self.x..","..self.y..")")
end

local Motorcycle, MotorcycleBase = class("Motorcycle", Car)

function Motorcycle:__init(x, y)
  Car.__init(self, x, y) -- if you want to use a parent's constructor, you must manually call it

  -- do additional stuff or whatever
end

function MotorcycleBase:someFunc()
  -- do whatever to an instance
end
