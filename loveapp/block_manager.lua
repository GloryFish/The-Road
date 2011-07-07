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
end

function Block:containsPoint(point)
  return point.x > self.position.x and
     point.x < self.position.x + self.size and
     point.y > self.position.y and
     point.y < self.position.y + self.size
end

BlockManager = class('BlockManager')
function BlockManager:initialize(level)
  self.blocks = {}
  self.blockSize = 16
  self.scale = 1
end

function BlockManager:addBlock(pos)
  local newBlock = Block(pos, self.blockSize)
  
  table.insert(self.blocks, newBlock)  
end

function BlockManager:update(dt)
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
end