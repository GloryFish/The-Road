-- 
--  background_parallax.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-18.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 


require 'vector'
require 'middleclass'

ParallaxImage = class('ParallaxImage')
function ParallaxImage:initialize(imageData, parallaxAmount)
  self.imageData = imageData
  self.parallaxAmount = parallaxAmount
end


BackgroundParallax = class('BackgroundParallax')
function BackgroundParallax:initialize()
  self.position = vector(0, 0)
  self.offset = vector(0, 0)
  self.bounds = {
    origin = vector(0,0),
    size = vector(0, 0)
  }
  self.images = {}
end

function BackgroundParallax:add(imageData)
  local newImage = ParallaxImage(imageData, 1)
  table.insert(self.images, newImage)
end

-- Call once per update, offset is the camera offset which the backgrounds will be translated relative to
function BackgroundParallax:setOffset(offset)
  self.offset = offset
end

function BackgroundParallax:draw()
  local overlayCount = #self.images
  local maxOverlayMovement = 0.75
  
  for i, image in ipairs(self.images) do
    love.graphics.push()
    love.graphics.translate(-self.offset.x * maxOverlayMovement / overlayCount * i, -self.offset.y * maxOverlayMovement / overlayCount * i)
    love.graphics.draw(image.imageData, 0, 0, 0, 4, 4)
    love.graphics.pop()
  end
end


