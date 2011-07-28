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
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
#############################
###########       ###########
########### S   G ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
###########       ###########
#############################
]]

-- 12, 18
-- 19

local triggers = {}

local tb = TriggerBuilder()

-- tb:add(triggers, 18, 19, 3)

tb:row(triggers, 18, 12, 19, 3, 1.5)
tb:row(triggers, 12, 18, 18, 9, 1.5)
tb:row(triggers, 18, 12, 17, 13, 1.5)
tb:row(triggers, 12, 18, 16, 15, 1.5)
tb:row(triggers, 18, 12, 15, 16, 1.5)

tb:column(triggers, 12, 14, 1, 17, 0.5)
tb:column(triggers, 18, 14, 1, 18, 0.5)

tb:row(triggers, 13, 17, 14, 22, 1.5)
tb:row(triggers, 17, 13, 13, 25, 1)
tb:row(triggers, 13, 17, 12, 27, 1)
tb:row(triggers, 17, 13, 11, 30, 1)
tb:row(triggers, 13, 17, 10, 32, 1)



local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, 'bequickaboutit'