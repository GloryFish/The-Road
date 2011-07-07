-- 
--  test.lua
--  The-Road
--  
--  A map with some testing tiles
--
--  Created by Jay Roberts on 2011-07-06.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'vector'

local tileset = love.graphics.newImage('resources/images/spritesheet.png')
tileset:setFilter('nearest', 'nearest')

local tileWidth, tileHeight = 32, 32

local quadInfo = { 
  { ' ', 1 * tileWidth, 0 * tileHeight}, -- 1 = air 
  { '#', 0 * tileWidth, 0 * tileHeight}, -- 2 = brick floor
  { ']', 0 * tileWidth, 0 * tileHeight}, -- 3 = brick wall left
  { '[', 0 * tileWidth, 0 * tileHeight}, -- 4 = brick wall right
  { '_', 0 * tileWidth, 0 * tileHeight}, -- 5 = brick ceiling
  { 'G', 3 * tileWidth, 0 * tileHeight}, -- 6 = goal
}

local solid = {
  '#',
  ']',
  '[',
  '_',
}


local quads = {}

for _,info in ipairs(quadInfo) do
  -- info[1] = character, info[2]= x, info[3] = y
  quads[info[1]] = love.graphics.newQuad(info[2], info[3], tileWidth, tileHeight, tileset:getWidth(), tileset:getHeight())
end


local tileString = [[
______________________________________________
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                                            [
]                     #                      [
]               #     #                      [
]                     ##                     [
]         #           ##                     [
] S #                 ##                G    [
##############################################
]]

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid