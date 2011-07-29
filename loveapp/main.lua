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
require 'level'
require 'scene_mainmenu'
require 'scene_game'
require 'input'
require 'logger'

unlocked = {'item'}

function love.load()
  debug = true
  
  love.graphics.setCaption('The Road')
  love.filesystem.setIdentity('The Road')
  
  -- Seed random
  local seed = os.time()
  math.randomseed(seed);
  math.random(); math.random(); math.random()  

  fonts = {
    default        = love.graphics.newFont('resources/fonts/silkscreen.ttf', 24),
    small          = love.graphics.newFont('resources/fonts/silkscreen.ttf', 20),
    tiny           = love.graphics.newFont('resources/fonts/gamegirl.ttf', 14),
    button         = love.graphics.newFont('resources/fonts/gamegirl.ttf', 18),
    buttonSelected = love.graphics.newFont('resources/fonts/gamegirl.ttf', 20),
    gamegirl       = love.graphics.newFont('resources/fonts/gamegirl.ttf', 18), -- http://www.fontspace.com/freaky-fonts/gamegirl-classic
  }

  music = {
    title = love.audio.newSource("resources/music/earthcrisis11.xm", 'stream'), -- http://modarchive.org/index.php?request=view_by_moduleid&query=170449
  }
  music.title:setLooping(true)
  
  
  sounds = {
    menumove = love.audio.newSource('resources/sounds/menu_move.mp3', 'static'),
    menuselect = love.audio.newSource('resources/sounds/menu_select.mp3', 'static'),
    crumble = love.audio.newSource('resources/sounds/crumble_1.mp3', 'static'),
  }
  
  input = Input()
  
  soundOn = true
  love.audio.setVolume(1)
  
  Gamestate.registerEvents()
  Gamestate.switch(mainmenu)

  unlocked = {'jimmy'}
  
  
  -- if love.filesystem.isFile('levels.txt') then
  --   unlocked = love.filesystem.lines('levels.txt')
  --   
  --   unlocked = {'arga'}
  -- else
  --   local file = love.filesystem.newFile("levels.txt")
  --   file:open('w')
  --   file:write('training-1\n')
  --   file:close()
  --   unlocked = {'training-1'}
  -- end
end


function love.update(dt)
end
