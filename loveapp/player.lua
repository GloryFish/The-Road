-- 
--  player.lua
--  redditgamejam-05
--  
--  Created by Jay Roberts on 2010-12-10.
--  Copyright 2010 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'vector'
require 'colors'

Player = class('Player')

function Player:initialize(pos)
  -- Sounds
  self.sounds = {
    jump = love.audio.newSource('resources/sounds/jump.mp3', 'static'),
  } 

  -- Tileset
  self.tileset = love.graphics.newImage('resources/images/spritesheet.png')
  self.tileset:setFilter('nearest', 'nearest')

  self.tileSize = 16
  self.scale = 2
  self.offset = vector(self.tileSize / 2, self.tileSize / 2)

  -- Quads, animation frames
  self.animations = {}
  
  self.animations['standing'] = {}
  self.animations['standing'].frameInterval = 0.5
  self.animations['standing'].quads = {
    love.graphics.newQuad(3 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
    love.graphics.newQuad(3 * self.tileSize, 1 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
  }
  
  self.animations['jumping'] = {}
  self.animations['jumping'].quads = {
    love.graphics.newQuad(5 * self.tileSize, 1 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight())
  }

  self.animations['falling'] = {}
  self.animations['falling'].quads = {
    love.graphics.newQuad(5 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight())
  }

  self.animations['walking'] = {}
	self.animations['walking'].frameInterval = 0.1
  self.animations['walking'].quads = {
    love.graphics.newQuad(4 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
		love.graphics.newQuad(4 * self.tileSize, 1 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
		love.graphics.newQuad(4 * self.tileSize, 2 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
		love.graphics.newQuad(4 * self.tileSize, 3 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
  }
  
  self.animations['dead'] = {}
  self.animations['dead'].quads = {
    love.graphics.newQuad(6 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight()),
  }

  self.animation = {}
  self.animation.current = 'standing'
  self.animation.frame = 1
  self.animation.elapsed = 0
  
  -- Instance vars
  self.flip = 1
  self.position = pos
  self.speed = 100
  self.onground = true
  self.onwall = false
  self.movement = vector(0, 0) -- This holds a vector containing the last movement input recieved
  self.dead = false
  
  self.velocity = vector(0, 0)
  self.jumpVector = vector(0, -250)
end

function Player:reset()
  self.animation.current = 'standing'
  self.animation.frame = 1
  self.animation.elapsed = 0
  self.flip = 1
  self.velocity = vector(0, 0)
  self.dead = false
end

-- Call during update with the joystick vector
function Player:setMovement(movement)
  self.movement = movement
  self.velocity.x = movement.x * self.speed
  
  if movement.x > 0 then
    self.flip = 1
  end

  if movement.x < 0 then
    self.flip = -1
  end

  if self.onground then
    if movement.x == 0 then
      self:setAnimation('standing')
    else
      self:setAnimation('walking')
    end    
  end
end

function Player:kill()
  self.dead = true
  self:setAnimation('dead')
end

-- Adjusts the player's y position so that it is standing on the floor value
function Player:setFloorPosition(floor)
  self.position.y = floor - self.tileSize / 2 * self.scale
end

function Player:jump()
  self.velocity = self.velocity + self.jumpVector
  self.onground = false
  self:setAnimation('jumping')
  if soundOn then
    love.audio.play(self.sounds.jump)
  end
end

function Player:wallslide()
  self.onwall = true
  self:setAnimation('wallsliding')
end

function Player:land()
  self.onground = true
  self.onwall = false
  self:setAnimation('standing')
  if soundOn then
    love.audio.play(self.sounds.land)
  end
end

-- TODO: Fix state code, make sure proper state transitions are maintained
-- make sure there is running, jumping, falling with correct changing between them
function Player:setAnimation(animation)
  if (self.animation.current ~= animation) then
    self.animation.current = animation
    self.animation.frame = 1
  end
end

-- Returns the world coordinates of the Player's corners. If pos is supplied it returns what the Player's
-- coordinates would be at that position
function Player:getCorners(pos)
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

function Player:update(dt)
  self.animation.elapsed = self.animation.elapsed + dt
  
  -- Handle animation
  if #self.animations[self.animation.current].quads > 1 then -- More than one frame
    local interval = self.animations[self.animation.current].frameInterval

    assert(interval, string.format('animation "%s" has multiple frames but has no frameInterval specified', self.animation.current))

    interval = interval + (interval - (interval * math.abs(self.movement.x)))
    
    if self.animation.elapsed > interval then -- Switch to next frame
      self.animation.frame = self.animation.frame + 1
      if self.animation.frame > #self.animations[self.animation.current].quads then -- Aaaand back around
        self.animation.frame = 1
      end
      self.animation.elapsed = 0
    end
  end
  
  -- Cap velocity
  if self.velocity.y > 500 then
    self.velocity.y = 500
  end
  
  -- Apply velocity to position
  self.position = self.position + self.velocity * dt
end
  
function Player:draw()
  colors.white:set()
  
  love.graphics.drawq(self.tileset,
                      self.animations[self.animation.current].quads[self.animation.frame], 
                      math.floor(self.position.x), 
                      math.floor(self.position.y),
                      0,
                      self.scale * self.flip,
                      self.scale,
                      self.offset.x,
                      self.offset.y)
end