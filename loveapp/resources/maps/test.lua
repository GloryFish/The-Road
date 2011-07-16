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

local backgrounds = {
 love.graphics.newImage('resources/images/background.png'), 
 love.graphics.newImage('resources/images/background-overlay.png'), 
}

for i, background in ipairs(backgrounds) do
  background:setFilter('nearest', 'nearest')
end


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
#                ###         #
#                ###         #
#    S           ###         #
#                ###         #
#                ###         #
#                ###         #
#                ###         #
#       ######## ###         #
#                ###         #
#                ###  G      #
#----------------###---------#
##############################
#                ###         #
#                ###         #
#                ###         #
#                ###         #
#                ###         #
#                ###         #
]]

local triggers = {}

local tb = TriggerBuilder()

tb:row(triggers, 10, 16, 4, 4, 0.5)
tb:row(triggers, 2, 24, 16, 2, 1)
tb:row(triggers, 2, 24, 15, 8, 1)
tb:row(triggers, 10, 17, 12, 9, 0.2)

tb:column(triggers, 18, 22, 5, 7, 0.15)
tb:column(triggers, 19, 22, 5, 8, 0.15)
tb:column(triggers, 20, 22, 5, 9, 0.5)

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, 'test'