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
function Block:initialize(pos, size)
  self.position = pos
  self.size = size
  self.velocity = vector(0, 0)
end

function Block:containsPoint(point)
  return point.x > self.position.x and
     point.x < self.position.x + self.size and
     point.y > self.position.y and
     point.y < self.position.y + self.size
end

function Block:setFloorPosition(floor)
  self.position.y = floor - self.size
end

function Block:getBottomCenter(point)
  local testPos = point
  if testPos == nil then
    testPos = self.position
  end
  
  return vector(testPos.x + self.size / 2, testPos.y + self.size)
end

BlockManager = class('BlockManager')
function BlockManager:initialize(level)
  self.blocks = {}
  self.blockSize = 16
  self.scale = 1
  self.level = level
  self.bounds = vector(self.level:getWidth(), self.level:getHeight()) -- World bounds are (0, 0, width, height)
end

function BlockManager:addBlock(pos)
  local newBlock = Block(pos, self.blockSize)
  
  table.insert(self.blocks, newBlock)  
end

function BlockManager:update(dt)
  local gravityAmount = 1
  
  local toRemove = {} -- Blocks we might want to remove because they are out of the world bounds
  
  for i, block in ipairs(self.blocks) do
    block.velocity = block.velocity + self.level.gravity * dt * gravityAmount -- Gravity

    if dt > 0.5 then
      self.player.velocity.y = 0
    end
    
    local newPos = block.position + block.velocity * dt
    
    local blockBottomPos = block:getBottomCenter(newPos)
    
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
  colors.red:set()
  for i, block in ipairs(self.blocks) do
    love.graphics.rectangle('fill', block.position.x, block.position.y, self.blockSize, self.blockSize)
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