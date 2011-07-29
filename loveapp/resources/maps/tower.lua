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
########### S     ###########
###########       ###########
###########     G ###########
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

-- 12, 19

local triggers = {}

local tb = TriggerBuilder()

tb:add(triggers, 12, 19, 2)
tb:add(triggers, 13, 19, 2)
tb:add(triggers, 12, 18, 2)
tb:add(triggers, 12, 17, 2)

tb:add(triggers, 13, 18, 6)
tb:add(triggers, 14, 18, 6)
tb:add(triggers, 14, 19, 6)
tb:add(triggers, 15, 19, 6)

tb:add(triggers, 17, 19, 8)
tb:add(triggers, 18, 19, 8)
tb:add(triggers, 18, 18, 8)
tb:add(triggers, 18, 17, 8)

tb:add(triggers, 15, 18, 11)
tb:add(triggers, 16, 18, 11)
tb:add(triggers, 17, 18, 11)
tb:add(triggers, 16, 19, 11)

tb:row(triggers, 12, 18, 17, 13, 0.7)
tb:row(triggers, 12, 18, 16, 16, 0.7)
tb:row(triggers, 12, 18, 15, 19, 0.7)
tb:row(triggers, 12, 18, 14, 21, 1)
tb:row(triggers, 12, 18, 13, 25, 1)
tb:row(triggers, 12, 18, 12, 28, 1.3)
tb:row(triggers, 12, 18, 11, 32, 1.3)
tb:row(triggers, 12, 18, 10, 35, 1.3)
tb:row(triggers, 12, 18, 9, 38, 1.3)
tb:row(triggers, 12, 18, 8, 42, 1.3)

tb:column(triggers, 9, 34, 30, 15, 1.5)
tb:column(triggers, 8, 34, 23, 15, 1.1)
tb:column(triggers, 7, 34, 27, 15, 1.7)
tb:column(triggers, 10, 34, 20, 25, 1.7)

tb:column(triggers, 21, 34, 25, 25, 1.5)
tb:column(triggers, 22, 34, 18, 25, 1.1)
tb:column(triggers, 23, 34, 22, 25, 1.7)
tb:column(triggers, 24, 34, 15, 35, 1.7)



local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, 'bequickaboutit'