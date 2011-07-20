-- 
--  paul.lua
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
#                                                                     #
#---------------------------------------------------------------------#
#                ###                                                  #
# #######        ###                                                  #
# #######        ###                        #######                   #
#                ###                                      #           #
#                ###       #################                 #        #
#       ######## ###                                                  #
#                ###                                                  #
#                                                                   G #
#----------------------------   ---   -  --    -----------------------#
#                ############                        ##################
#                ###                             ##  ##################
#                ###         #  ###   #  ##    ####  ##################
#                ###      #     ###   #  ##    ########################
#                ###   #        ###   #  ##    ########################
#                ###            ###   #  ##    ########################
#               ####            ###   #  ##    ########################
]]

local triggers = {}

local tb = TriggerBuilder()

-- starting block, ending block, row, starting time from beginning of level, duration of activation

tb:row(triggers, 3, 18, 4, 18, 0)
tb:row(triggers, 3, 9, 6, 2, 0)
tb:row(triggers, 17, 17, 6, 8, 0)
tb:row(triggers, 18, 18, 14, 10, 0)
tb:row(triggers, 50, 65, 6, 22, .5)

tb:column(triggers, 18, 20, 18, 7, 0.15)
tb:column(triggers, 18, 20, 19, 7, 0.16)
tb:column(triggers, 18, 20, 20, 7, 0.17)

-- tb:column(triggers, 18, 22, 5, 7, 0.15)

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, 'jay'