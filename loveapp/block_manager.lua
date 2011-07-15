-- 
--  block_manager.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-07.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 


require 'middleclass'
require 'colors'
require 'vector'

Block = class('Block')
function Block:initialize(pos, size, scale, delay)
  self.position = pos
  self.size = size
  self.scale = scale
  self.velocity = vector(0, 0)
  -- self.tileset and self.quads should be set by the parent level

  self.state = 'activating'
  self.activatingDuration = delay
  if delay == nil then
    self.activatingDuration = 3
  end
  
end

function Block:containsPoint(point)
  return point.x > self.position.x and
     point.x < self.position.x + self.size * self.scale and
     point.y > self.position.y and
     point.y < self.position.y + self.size * self.scale
end

function Block:setFloorPosition(floor)
  self.position.y = floor - (self.size * self.scale)
end

function Block:getBottomCenter(point)
  local testPos = point
  if testPos == nil then
    testPos = self.position
  end
  
  return vector(testPos.x + (self.size * self.scale) / 2, testPos.y + (self.size * self.scale))
end

BlockManager = class('BlockManager')
function BlockManager:initialize(level)
  self.blocks = {}
  self.blockSize = 16
  self.scale = 2
  self.level = level
  self.bounds = vector(self.level:getWidth(), self.level:getHeight()) -- World bounds are (0, 0, width, height)
end

function BlockManager:reset()
  self.blocks = {}
end

function BlockManager:addBlock(pos, delay)
  local newBlock = Block(pos, self.blockSize, self.scale, delay)
  
  table.insert(self.blocks, newBlock)  
end

function BlockManager:update(dt)
  local gravityAmount = 1
  
  local toRemove = {} -- Blocks we might want to remove because they are out of the world bounds
  
  for i, block in ipairs(self.blocks) do
    if block.state == 'activating' then
      block.activatingDuration = block.activatingDuration - dt
      if block.activatingDuration < 0 then
        block.state = 'active'
      end
    end

    -- Gravity
    if block.state == 'active' then
      block.velocity = block.velocity + self.level.gravity * dt * gravityAmount -- Gravity

      if dt > 0.5 then
        self.player.velocity.y = 0
      end

      local newPos = block.position + block.velocity * dt

    end
    
    local blockBottomPos = block:getBottomCenter(newPos)
    
    -- Collision
    if block.velocity.y > 0 then -- Falling
      if not self.level:pointIsWalkable(blockBottomPos) then -- Collide with bottom
        block:setFloorPosition(self.level:floorPosition(blockBottomPos))
        block.velocity.y = 0
      end
    end

    block.position = block.position + block.velocity * dt
    
    -- If the block is outside of the world bounds, destroy it
    if block.position.y > self.bounds.y then 
      table.insert(toRemove, i)
    end
  end
  
  for i, v in ipairs(toRemove) do
     table.remove(self.blocks, v - i + 1)
  end
end

function BlockManager:draw()
  for i, block in ipairs(self.blocks) do
    local quad = 'A'
    local jitter = vector(0, 0)
    
    if block.state == 'activating' then
      quad = 'a'
      
      jitter.x = math.random(-2, 2)
      jitter.y = math.random(-2, 2)
    end
    
    
    love.graphics.drawq(self.tileset,
                        self.quads[quad], 
                        block.position.x + jitter.x, 
                        block.position.y + jitter.y, 
                        0,
                        self.scale,
                        self.scale)
  end
end

function BlockManager:pointIsWalkable(point)
  for i, block in ipairs(self.blocks) do
    if block:containsPoint(point) then
      return false
    end
  end
  return true
end

function BlockManager:pointIsLethal(point)
  for i, block in ipairs(self.blocks) do
    if block.velocity.y > 0 then
      if block:containsPoint(point) then
        return true
      end
    end
  end
  return false
end