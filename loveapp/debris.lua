-- 
--  debris.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-18.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'vector'
require 'middleclass'

Debris = class('Debris')
function Debris:initialize()
  
  self.image = love.graphics.newImage('resources/images/debris.png')
  self.image:setFilter('nearest', 'nearest')
  
  self.particles = love.graphics.newParticleSystem(self.image, 500)
  
  self.position = vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

	self.particles:setEmissionRate(3)
  self.particles:setSpeed(0, 0)
  self.particles:setGravity(50)
  self.particles:setSizes(3, 0.5)
  self.particles:setColors(255, 255, 255, 255, 58, 128, 255, 0)
  self.particles:setPosition(self.position.x, self.position.y)
  self.particles:setLifetime(-1)
  self.particles:setParticleLife(2)
  self.particles:setDirection(math.pi / 2)
  self.particles:setRotation(0, math.pi)
  self.particles:setSpread(10)
end

function Debris:start()
  self.particles:start()
end

function Debris:stop()
  self.particles:stop()
end

function Debris:update(dt)
  self.particles:setPosition(self.position.x, self.position.y)
  self.particles:update(dt)
end


function Debris:draw()
  love.graphics.draw(self.particles)
end