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
require 'trigger_builder'

local tileset = love.graphics.newImage('resources/images/spritesheet.png')
tileset:setFilter('nearest', 'nearest')

local background = love.graphics.newImage('resources/images/background.png')
background:setFilter('nearest', 'nearest')


local tileWidth, tileHeight = 16, 16

local quadInfo = { 
  { '-', 0 * tileWidth, 0 * tileHeight}, -- 3 = mossy stone
  { 'm', 0 * tileWidth, 1 * tileHeight}, -- 6 = mossy stone activating
  { '#', 1 * tileWidth, 0 * tileHeight}, -- 2 = normal stone
  { 'n', 1 * tileWidth, 1 * tileHeight}, -- 6 = normal stone activating
  { 'A', 0 * tileWidth, 2 * tileHeight}, -- 6 = active stone
  { ' ', 1 * tileWidth, 3 * tileHeight}, -- 1 = air 
  { 'G', 2 * tileWidth, 0 * tileHeight}, -- 6 = goal
}

local solid = {
  '#',
  '-',
}


local quads = {}

for _,info in ipairs(quadInfo) do
  -- info[1] = character, info[2]= x, info[3] = y
  quads[info[1]] = love.graphics.newQuad(info[2], info[3], tileWidth, tileHeight, tileset:getWidth(), tileset:getHeight())
end


local tileString = [[
##############################
##############################
##############################
##############################
#                            #
#                            #
#    S                       #
#                            #
#                            #
#                            #
#                            #
#       ########             #
#                            #
#                     G      #
#----------------------------#
##############################
#                            #
#                            #
#                            #
#                            #
#                            #
#                            #
]]

local triggers = {}

local tb = TriggerBuilder()
tb:row(triggers, 9, 15, 3, 4, 0.5)
tb:row(triggers, 1, 23, 15, 2, 1)
tb:row(triggers, 1, 23, 14, 8, 1)

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, background, 'test'