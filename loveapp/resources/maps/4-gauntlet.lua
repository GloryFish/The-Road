-- 
--  gauntlet.lua
--  The-Road
--  Paul rules.
--  Created by Jay Roberts on 2011-07-16.
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
#######################################################################
#S#####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
# #####################################################################
#                                                                     #
#                                                                     #
#                                                                     #
#                                                                     #
#                                                                     #
#                                                                    G#
######   ######   #######    ######  ##   ## # # # # ## #### ##########
######   ######   #######    ######  ##   ## # # # # ## #### ##########
#                                                                     #
#                                                                     #
#                                                                     #
#                                                                     #
]]

local triggers = {}

local tb = TriggerBuilder()

-- starting block, ending block, row, starting time from beginning of level, duration of activation

tb:row(triggers, 7, 7, 10, 0, 0)
tb:row(triggers, 8, 8, 10, .5, 1)
tb:row(triggers, 9, 9, 10, 1, 2)
tb:row(triggers, 7, 7, 9, 2.5, 0)
tb:row(triggers, 8, 8, 9, 3, 1)
tb:row(triggers, 9, 9, 9, 3.5, 2)
tb:row(triggers, 7, 7, 8, 4, 0)
tb:row(triggers, 8, 8, 8, 4.5, 1)
tb:row(triggers, 9, 9, 8, 5, 2)
tb:row(triggers, 7, 7, 7, 5.5, 0)
tb:row(triggers, 8, 8, 7, 6, 1)
tb:row(triggers, 9, 9, 7, 6.5, 2)
tb:row(triggers, 7, 7, 6, 7, 0)
tb:row(triggers, 8, 8, 6, 8, 1)
tb:row(triggers, 9, 9, 6, 9, 2)
tb:row(triggers, 7, 7, 5, 10, 0)
tb:row(triggers, 8, 8, 5, 11, 1)
tb:row(triggers, 9, 9, 5, 12, 2)
tb:row(triggers, 7, 7, 4, 13, 0)
tb:row(triggers, 8, 8, 4, 14, 1)
tb:row(triggers, 9, 9, 4, 15, 2)
tb:row(triggers, 7, 7, 3, 16, 0)
tb:row(triggers, 8, 8, 3, 17, 1)
tb:row(triggers, 9, 9, 3, 18, 2)
tb:row(triggers, 7, 7, 2, 19, 0)
tb:row(triggers, 8, 8, 2, 20, 1)
tb:row(triggers, 9, 9, 2, 21, 2)
tb:row(triggers, 7, 7, 1, 22, 0)
tb:row(triggers, 8, 8, 1, 23, 1)
tb:row(triggers, 9, 9, 1, 24, 2)
-- platform
tb:row(triggers, 2, 6, 17, 20, 0)
tb:row(triggers, 2, 6, 18, 21, 1)

tb:row(triggers, 16, 16, 10, .5, 0)
tb:row(triggers, 17, 17, 10, 1, 1)
tb:row(triggers, 18, 18, 10, 1.5, 2)
tb:row(triggers, 16, 16, 9, 3, 0)
tb:row(triggers, 17, 17, 9, 3.5, 1)
tb:row(triggers, 18, 18, 9, 4, 2)
tb:row(triggers, 16, 16, 8, 4.5, 0)
tb:row(triggers, 17, 17, 8, 5, 1)
tb:row(triggers, 18, 18, 8, 5.5, 2)
tb:row(triggers, 16, 16, 7, 6, 0)
tb:row(triggers, 17, 17, 7, 7, 1)
tb:row(triggers, 18, 18, 7, 8, 2)
tb:row(triggers, 16, 16, 6, 9, 0)
tb:row(triggers, 17, 17, 6, 10, 1)
tb:row(triggers, 18, 18, 6, 11, 2)
tb:row(triggers, 16, 16, 5, 12, 0)
tb:row(triggers, 17, 17, 5, 13, 1)
tb:row(triggers, 18, 18, 5, 14, 2)
tb:row(triggers, 16, 16, 4, 15, 0)
tb:row(triggers, 17, 17, 4, 16, 1)
tb:row(triggers, 18, 18, 4, 17, 2)
tb:row(triggers, 16, 16, 3, 18, 0)
tb:row(triggers, 17, 17, 3, 21, 1)
tb:row(triggers, 18, 18, 3, 22, 2)
tb:row(triggers, 16, 16, 2, 23, 0)
tb:row(triggers, 17, 17, 2, 24, 1)
tb:row(triggers, 18, 18, 2, 25, 2)
tb:row(triggers, 16, 16, 1, 26, 0)
tb:row(triggers, 17, 17, 1, 27, 1)
tb:row(triggers, 18, 18, 1, 28, 2)
-- platform
tb:row(triggers, 10, 15, 17, 25, 0)
tb:row(triggers, 10, 15, 18, 24, 1)

tb:row(triggers, 26, 26, 10, 4, 0)
tb:row(triggers, 27, 27, 10, 4.5, 1)
tb:row(triggers, 28, 28, 10, 5, 2)
tb:row(triggers, 26, 26, 9, 7, 0)
tb:row(triggers, 27, 27, 9, 7.5, 1)
tb:row(triggers, 28, 28, 9, 8, 2)
tb:row(triggers, 26, 26, 8, 9, 0)
tb:row(triggers, 27, 27, 8, 9.5, 1)
tb:row(triggers, 28, 28, 8, 10, 2)
tb:row(triggers, 26, 26, 7, 11, 0)
tb:row(triggers, 27, 27, 7, 12, 1)
tb:row(triggers, 28, 28, 7, 13, 2)
tb:row(triggers, 26, 26, 6, 11.5, 0)
tb:row(triggers, 27, 27, 6, 12, 1)
tb:row(triggers, 28, 28, 6, 12.5, 2)
tb:row(triggers, 26, 26, 5, 13, 0)
tb:row(triggers, 27, 27, 5, 13.5, 1)
tb:row(triggers, 28, 28, 5, 14.5, 2)
tb:row(triggers, 26, 26, 4, 15.5, 0)
tb:row(triggers, 27, 27, 4, 16, 1)
tb:row(triggers, 28, 28, 4, 17, 2)
tb:row(triggers, 26, 26, 3, 17.5, 0)
tb:row(triggers, 27, 27, 3, 18, 1)
tb:row(triggers, 28, 28, 3, 19, 2)
tb:row(triggers, 26, 26, 2, 20, 0)
tb:row(triggers, 27, 27, 2, 21, 1)
tb:row(triggers, 28, 28, 2, 22, 2)
tb:row(triggers, 26, 26, 1, 23, 0)
tb:row(triggers, 27, 27, 1, 24, 1)
tb:row(triggers, 28, 28, 1, 25, 2)
-- platform
tb:row(triggers, 19, 25, 17, 23, 1)
tb:row(triggers, 19, 25, 18, 23, 0)

tb:row(triggers, 41, 41, 10, 19, 0)
tb:row(triggers, 42, 42, 10, 19.5, 1)
tb:row(triggers, 41, 41, 9, 20, 0)
tb:row(triggers, 42, 42, 9, 21, 1)
tb:row(triggers, 41, 41, 8, 22, 0)
tb:row(triggers, 42, 42, 8, 23, 1)
tb:row(triggers, 41, 41, 7, 24, 0)
tb:row(triggers, 42, 42, 7, 25, 1)
tb:row(triggers, 41, 41, 6, 26, 0)
tb:row(triggers, 42, 42, 6, 27, 1)
tb:row(triggers, 41, 41, 5, 28, 0)
tb:row(triggers, 42, 42, 5, 29, 1)
tb:row(triggers, 41, 41, 4, 30, 0)
tb:row(triggers, 42, 42, 4, 31, 1)
tb:row(triggers, 41, 41, 3, 32, 0)
tb:row(triggers, 42, 42, 3, 33, 1)
tb:row(triggers, 41, 41, 2, 34, 0)
tb:row(triggers, 42, 42, 2, 35, 1)
tb:row(triggers, 41, 41, 1, 36, 0)
tb:row(triggers, 42, 42, 1, 37, 1)
-- platform
tb:row(triggers, 38, 39, 17, 34, 1)
tb:row(triggers, 38, 39, 18, 33, 0)

tb:row(triggers, 45, 45, 10, 23, 1)
tb:row(triggers, 45, 45, 9, 25, 1)
tb:row(triggers, 45, 45, 8, 27, 1)
tb:row(triggers, 45, 45, 7, 29, 1)
tb:row(triggers, 45, 45, 6, 31.5, 1)
tb:row(triggers, 45, 45, 5, 33, 1)
tb:row(triggers, 45, 45, 4, 35, 1)
tb:row(triggers, 45, 45, 3, 36, 1)
tb:row(triggers, 45, 45, 2, 36.5, 1)
tb:row(triggers, 45, 45, 1, 37, 1)
-- platform
tb:row(triggers, 43, 44, 17, 35, 1)
tb:row(triggers, 43, 44, 18, 35, 0)

tb:row(triggers, 49, 49, 10, 26, 1)
tb:row(triggers, 49, 49, 9, 27, 1)
tb:row(triggers, 49, 49, 8, 29, 1)
tb:row(triggers, 49, 49, 7, 31, 1)
tb:row(triggers, 49, 49, 6, 33, 1)
tb:row(triggers, 49, 49, 5, 34, 1)
tb:row(triggers, 49, 49, 4, 36, 1)
tb:row(triggers, 49, 49, 3, 38, 1)
tb:row(triggers, 49, 49, 2, 39, 1)
tb:row(triggers, 49, 49, 1, 40, 1)
-- platform
tb:row(triggers, 46, 46, 17, 38, 1)
tb:row(triggers, 46, 46, 18, 38, 0)
tb:row(triggers, 48, 48, 17, 38, 1)
tb:row(triggers, 48, 48, 18, 38, 0)

tb:row(triggers, 49, 49, 10, 26, 1)
tb:row(triggers, 49, 49, 9, 27, 1)
tb:row(triggers, 49, 49, 8, 29, 1)
tb:row(triggers, 49, 49, 7, 31, 1)
tb:row(triggers, 49, 49, 6, 33, 1)
tb:row(triggers, 49, 49, 5, 34, 1)
tb:row(triggers, 49, 49, 4, 36, 1)
tb:row(triggers, 49, 49, 3, 38, 1)
tb:row(triggers, 49, 49, 2, 39, 1)
tb:row(triggers, 49, 49, 1, 40, 1)

tb:row(triggers, 43, 66, 10, 45, 1)
tb:row(triggers, 43, 66, 9, 46, 1)
tb:row(triggers, 43, 66, 8, 47, 1)
tb:row(triggers, 43, 66, 7, 48, 1)
tb:row(triggers, 43, 66, 6, 49, 1)
tb:row(triggers, 43, 66, 5, 50, 1)
tb:row(triggers, 43, 66, 4, 51, 1)
tb:row(triggers, 43, 66, 3, 52, 1)
tb:row(triggers, 43, 66, 2, 53, 1)
tb:row(triggers, 43, 66, 1, 54, 1)


-- tb:column(triggers, 18, 22, 5, 7, 0.15)

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, '5-tower'