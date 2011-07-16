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
require 'text_typer'
require 'scene_game'

mainmenu = Gamestate.new()

function mainmenu.enter(self, pre)
  self.log = Logger(vector(10, 10))
  self.log.color = colors.white
  
  self.level = Level('mainmenu')
  
  local title = "The Road Won't Rise to Meet You"
  local titleWidth = fonts.gamegirl:getWidth(title)
  local titlePos = vector((love.graphics.getWidth() / 2) - (titleWidth / 2), 400)
  self.texttyper = TextTyper(title, fonts.gamegirl, titlePos, 15, colors.lightest)
  
  self.camera = Camera()
  self.camera.bounds = {
    top = 0 - 1000,
    right = math.max(self.level:getWidth() + 1000, love.graphics.getWidth()),
    bottom = math.max(self.level:getHeight()  + 1000, love.graphics.getHeight()),
    left = 0 - 1000
  }
  self.camera.position = vector(325, 300)
  self.camera:update(0)
  
  self.menu = Menu(vector(love.graphics.getWidth() / 2, 270))
  
  local startButton = TextButton('Test')
  startButton.action = self.runTestLevel
  self.menu:addButton(startButton)

  local quitButton = TextButton('Quit')
  quitButton.action = function() love.event.push('q') end
  self.menu:addButton(quitButton)
  
  music.title:setVolume(0.5)
  love.audio.play(music.title)
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
  self.texttyper:update(dt)
  self.camera:update(dt)
end

function mainmenu.draw(self)
  -- Backgrounds
  love.graphics.push()
  love.graphics.scale(self.camera.scale)
  
  colors.white:set()
  local overlayCount = #self.level.backgrounds
  local maxOverlayMovement = 0.75
  
  for i, background in ipairs(self.level.backgrounds) do
    love.graphics.push()
    love.graphics.translate(-self.camera.offset.x * maxOverlayMovement / overlayCount * i, -self.camera.offset.y * maxOverlayMovement / overlayCount * i)
    love.graphics.draw(background, 0, 0, 0, 4, 4)
    love.graphics.pop()
  end

  -- Level
  love.graphics.push()
  love.graphics.translate(-self.camera.offset.x, -self.camera.offset.y)
  self.level:draw()
  love.graphics.pop()

  love.graphics.pop()
  
  love.graphics.translate(0, 0)  
  self.texttyper:draw()

  self.menu:draw()
  
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