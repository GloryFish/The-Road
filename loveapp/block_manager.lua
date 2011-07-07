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
function Block:initialize()
  self.position = vector(0, 0)
end




BlockManager = class('BlockManager')
function BlockManager:initialize(level)
  self.blocks = {}
  self.blockSize = 16
  self.scale = 1
end

function BlockManager:addBlock(pos)
  local newBlock = Block()
  newBlock.position = pos
  
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