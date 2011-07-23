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
# #######        ###                                        ###########
# #######        ###         ##             #######        #          #
#                ###           #############              #           #
#                ###                                         ######   #
#       ######## ###                                        #         #
##               ###                                       #          #
#                                                                    G#
#----------------------------   ---   -  --   ------------------------#
#                ############                        ##################
#                ###                             ##  ##################
#                ###         #  ###   #  ##    ####  ##################
#                ###      #     ###   #  ##    ########################
#                      #        ###   #  ##    ########################
#                               ###   #  ##    ########################
#               ####            ###   #  ##    ########################
]]

local triggers = {}

local tb = TriggerBuilder()

-- starting block, ending block, row, starting time from beginning of level, duration of activation

tb:row(triggers, 2, 17, 6, 1, .1)
tb:row(triggers, 18, 45, 6, 5, .1)
tb:row(triggers, 32, 71, 1, 5, .1)
tb:row(triggers, 32, 71, 2, 8, .1)
tb:row(triggers, 32, 71, 3, 7, .1)
tb:row(triggers, 32, 71, 4, 6, .1)
tb:row(triggers, 32, 71, 6, 15, .1)
tb:row(triggers, 3, 9, 8, 3, .1)
tb:row(triggers, 3, 9, 9, 3, .1)
tb:row(triggers, 60, 69, 15, 17, .1)
tb:row(triggers, 60, 69, 16, 17, .1)
tb:row(triggers, 60, 69, 17, 17, .2)
tb:row(triggers, 60, 69, 18, 17, .3)
tb:row(triggers, 60, 69, 19, 17, .2)
tb:row(triggers, 60, 69, 20, 17, .3)
tb:row(triggers, 60, 69, 21, 17, .3)
tb:row(triggers, 60, 69, 22, 17, .2)
tb:row(triggers, 60, 69, 23, 17, .2)
tb:column(triggers, 18, 20, 18, 1, 0.5)
tb:column(triggers, 18, 20, 19, 1, 0.5)

-- tb:column(triggers, 18, 22, 5, 7, 0.15)

local gravity = vector(0, 600)

return tileset, quads, tileString, tileWidth, gravity, solid, triggers, backgrounds, 'jay'