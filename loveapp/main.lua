-- 
--  main.lua
--  xenofarm
--  
--  Created by Jay Roberts on 2011-01-20.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'middleclass-extras'

require 'gamestate'
require 'scene_game'
require 'logger'

function love.load()
  debug = true
  
  
  love.graphics.setCaption('Desert Loot')

  -- Seed random
  local seed = os.time()
  math.randomseed(seed);
  math.random(); math.random(); math.random()  

  fonts = {
    default        = love.graphics.newFont('resources/fonts/silkscreen.ttf', 24),
    small          = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
    tiny           = love.graphics.newFont('resources/fonts/silkscreen.ttf', 14),
    button         = love.graphics.newFont('resources/fonts/silkscreen.ttf', 48),
    buttonSelected = love.graphics.newFont('resources/fonts/silkscreen.ttf', 52)
  }

  music = {
  }
  
  sounds = {
    menuselect = love.audio.newSource('resources/sounds/select.mp3', 'static')
  }
  
  Gamestate.registerEvents()
  Gamestate.switch(game)
end

function love.update(dt)
end
