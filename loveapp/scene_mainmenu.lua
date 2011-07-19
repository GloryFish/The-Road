-- 
--  scene_mainmenu.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-16.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'vector'
require 'menu'
require 'textbutton'
require 'level'
require 'camera'
require 'scene_game'
require 'logo'

mainmenu = Gamestate.new()

function mainmenu.enter(self, pre)
  self.log = Logger(vector(10, 10))
  self.log.color = colors.white
  
  self.level = Level('mainmenu')
  
  self.logo = Logo('resources/images/logo.png')
  self.logo.position = vector(110, 50)
  self.logo:fadeIn()
  
  self.camera = Camera()
  self.camera.bounds = {
    top = 0 - 1000,
    right = math.max(self.level:getWidth() + 1000, love.graphics.getWidth()),
    bottom = math.max(self.level:getHeight()  + 1000, love.graphics.getHeight()),
    left = 0 - 1000
  }
  self.camera.position = vector(325, 300)
  self.camera.focus = vector(325, 300)
  self.camera:update(0)
  
  self.menu = Menu(vector(love.graphics.getWidth() / 2, 300))
  
  local startButton = TextButton('Test')
  startButton.action = self.runTestLevel
  self.menu:addButton(startButton)

	local paulsLevelButton = TextButton("Paul's Level")
  paulsLevelButton.action = function()
    debug = true
    game.level = Level('paul')
    Gamestate.switch(game)
  end
  
  self.menu:addButton(paulsLevelButton)

  local jaysLevelButton = TextButton("Jay's Level")
  jaysLevelButton.action = function()
    debug = true
    game.level = Level('jay')
    Gamestate.switch(game)
  end
  
  self.menu:addButton(jaysLevelButton)

  local quitButton = TextButton('Quit')
  quitButton.action = function() love.event.push('q') end
  self.menu:addButton(quitButton)
  
  self.background = BackgroundParallax(vector(self.level:getWidth(), self.level:getHeight()))
  for i, background in ipairs(self.level.backgrounds) do
    self.background:add(background)
  end

  if soundOn then
    music.title:setVolume(0.5)
    love.audio.play(music.title)
  end
  
  self.timer = require 'timer'
  self.cameraMover = self.timer.Oscillator(60, function(frac)
    if frac < 0.5 then
      frac = frac * 2
    else
      frac = 1 - (frac - 0.5) * 2
    end
  
    self.camera.position.x = 320 + (3260 * frac)
  end)
end

function mainmenu.mousepressed(self, x, y, button)
  self.menu:mousepressed(vector(x, y))

  if debug and button == 'r' then
    local mouse = vector(love.mouse.getX(), love.mouse.getY()) + self.camera.offset
    self.camera.focus = mouse
  end
  
  if debug and button == 'wu' then
    self.camera.scale = self.camera.scale + 0.2
  end

  if debug and button == 'wd' then
    self.camera.scale = self.camera.scale - 0.2
  end
  
end

function mainmenu.mousereleased(self, x, y, button)
  self.menu:mousereleased(vector(x, y))
end

function mainmenu.update(self, dt)
  if debug then
    self.log:update(dt)
    self.log:addLine(string.format('Camera: %s', tostring(self.camera.position)))
    self.log:addLine(string.format('FPS: %s', tostring(love.timer.getFPS())))
  end
  self.level:update(dt)
  self.cameraMover(dt)
  self.camera:update(dt)
  self.logo:update(dt)
  self.background:setOffset(self.camera.offset)
end

function mainmenu.draw(self)
  -- Backgrounds
  self.background:draw()

  -- Level
  love.graphics.push()
  love.graphics.translate(-self.camera.offset.x, -self.camera.offset.y)
  self.level:draw()
  love.graphics.pop()

  love.graphics.pop()
  
  love.graphics.translate(0, 0)  

  self.menu:draw()
  
  self.logo:draw()
  
  if debug then
    self.log:draw()
  end
end

function mainmenu.runTestLevel(self)
  debug = true
  game.level = Level('test')
  Gamestate.switch(game)
end


function mainmenu.leave(self)
  
end