-- 
--  goal.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-15.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 


require 'middleclass'
require 'vector'
require 'colors'

Goal = class('Goal')

function Goal:initialize(pos)
 -- Tileset
  self.tileset = love.graphics.newImage('resources/images/spritesheet.png')
  self.tileset:setFilter('nearest', 'nearest')

  self.tileSize = 16
  self.scale = 2
  self.offset = vector(self.tileSize / 2, self.tileSize / 2)
 
  -- Quads, animation frames
  self.animations = {}
  
  self.animations['waving'] = {}
  self.animations['waving'].frameInterval = 0.5
  self.animations['waving'].quads = {
    love.graphics.newQuad(2 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
    love.graphics.newQuad(2 * self.tileSize, 1 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
    love.graphics.newQuad(2 * self.tileSize, 2 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
    love.graphics.newQuad(2 * self.tileSize, 3 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
  }

  self.animation = {}
  self.animation.current = 'waving'
  self.animation.frame = 1
  self.animation.elapsed = 0
  
  -- Instance vars
  self.position = pos
end

function Goal:reset()
  self.animation.current = 'waving'
  self.animation.frame = 1
  self.animation.elapsed = 0
  self.flip = 1
end


-- Adjusts the goals's y position so that it is standing on the floor value
function Goal:setFloorPosition(floor)
  self.position.y = floor - self.tileSize / 2 * self.scale
end

-- TODO: Fix state code, make sure proper state transitions are maintained
-- make sure there is running, jumping, falling with correct changing between them
function Goal:setAnimation(animation)
  if (self.animation.current ~= animation) then
    self.animation.current = animation
    self.animation.frame = 1
  end
end

-- Returns the world coordinates of the goal's corners. If pos is supplied it returns what the goal's
-- coordinates would be at that position
function Goal:getCorners(pos)
  if pos == nil then
    pos = self.position
  end
  
  local margin = 4
  
  local ul, ur, bl, br = vector(math.floor(pos.x - (self.tileSize / 2 * self.scale)), math.floor(pos.y - (self.tileSize / 2 * self.scale))), -- UL
                         vector(math.floor(pos.x + (self.tileSize / 2 * self.scale)), math.floor(pos.y - (self.tileSize / 2 * self.scale))), -- UR
                         vector(math.floor(pos.x - (self.tileSize / 2 * self.scale)), math.floor(pos.y + (self.tileSize / 2 * self.scale))), -- BL
                         vector(math.floor(pos.x + (self.tileSize / 2 * self.scale)), math.floor(pos.y + (self.tileSize / 2 * self.scale))) -- BR

  -- Make the width just a bt smaller cause our ninja is skinny
  ul.x = ul.x + margin
  ur.x = ur.x - margin
  bl.x = bl.x + margin
  br.x = br.x - margin
  
  return ul, ur, bl, br
  
end

function Goal:update(dt)
  self.animation.elapsed = self.animation.elapsed + dt
  
  -- Handle animation
  if #self.animations[self.animation.current].quads > 1 then -- More than one frame
    local interval = self.animations[self.animation.current].frameInterval

    assert(interval, string.format('animation "%s" has multiple frames but has no frameInterval specified', self.animation.current))

    if self.animation.elapsed > interval then -- Switch to next frame
      self.animation.frame = self.animation.frame + 1
      if self.animation.frame > #self.animations[self.animation.current].quads then -- Aaaand back around
        self.animation.frame = 1
      end
      self.animation.elapsed = 0
    end
  end
end
  
function Goal:draw()
  colors.white:set()
  
  love.graphics.drawq(self.tileset,
                      self.animations[self.animation.current].quads[self.animation.frame], 
                      math.floor(self.position.x), 
                      math.floor(self.position.y),
                      0,
                      self.scale,
                      self.scale,
                      self.offset.x,
                      self.offset.y)
end