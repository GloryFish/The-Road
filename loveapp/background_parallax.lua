-- 
--  background_parallax.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-18.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 


require 'vector'
require 'middleclass'

ParallaxImage = class(ParallaxImage)
function ParallaxImage:initialize(image, parallaxAmount)
  self.image = image
  self.parallaxAmount = parallaxAmount
end



BackgroundParallax = class('BackgroundParallax')
function BackgroundParallax:initialize()
  self.position = vector(0, 0)
  self.bounds = {
    origin = vector(0,0),
    size = vector(0, 0)
  }
  self.images = {}
end

function BackgroundParallax:add(image)
  
  
  
end

function BackgroundParallax:draw()
end


