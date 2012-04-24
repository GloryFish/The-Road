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
  
  self.timer = require 'timer'
  
  self.level = Level('mainmenu')
  
  self.logo = Logo('resources/images/logo.png')
  self.logo.position = vector(110, 50)
  self.logo:fadeIn()
  
  self.mainPosition = vector(325, 300) 
  self.levelSelectPosition = vector(850, 300) 
  self.instructionsPosition = vector(1375, 300) 
  
  if self.camera == nil then
    self.camera = Camera()
    self.camera.bounds = {
      top = 0 - 1000,
      right = math.max(self.level:getWidth() + 1000, love.graphics.getWidth()),
      bottom = math.max(self.level:getHeight()  + 1000, love.graphics.getHeight()),
      left = 0 - 1000
    }
  end    

  self.camera.position = vector(325, 300)
  self.camera.focus = vector(325, 300)
  self.camera.deadzone = 5
  self.camera:update(0)
  
  -- Main Mneu
  self.menuMain = Menu(vector(320, 300))

  local newGameButton = TextButton('New Game')
  newGameButton.action = function()
    game.level = Level('1-walking')
    Gamestate.switch(game)
  end
  self.menuMain:addButton(newGameButton)

  
  local levelSelectButton = TextButton('Level Select')
  levelSelectButton.action = function()
    self.camera.focus.x = self.levelSelectPosition.x
    self.timer.add(0.1, function()
      self.menuActive = self.menuLevel
    end)
  end
  self.menuMain:addButton(levelSelectButton)

  local instructionsButton = TextButton('Instructions')
  instructionsButton.action = function()
    self.camera.focus.x = self.instructionsPosition.x
    self.timer.add(0.1, function()
      self.menuActive = self.menuInstructions
    end)
  end
  self.menuMain:addButton(instructionsButton)

  local quitButton = TextButton('Quit')
  quitButton.action = function() love.event.push('quit') end
  self.menuMain:addButton(quitButton)

  -- Level Select Menu
  self.menuLevel = Menu(vector(self.levelSelectPosition.x, 100))
  
  local backButton = TextButton('Back')
  backButton.action = function()
    self.camera.focus.x = self.mainPosition.x
    self.timer.add(0.1, function()
      self.menuActive = self.menuMain
    end)
  end
  self.menuLevel:addButton(backButton)

  local levels = love.filesystem.enumerate('resources/maps/')
  for i, levelName in ipairs(levels) do
    levelName = string.sub(levelName, 1, -5)
  
    if table.contains(unlocked, levelName) then
      local button = TextButton(levelName)
      button.action = function()
        game.level = Level(levelName)
        Gamestate.switch(game)
      end
      self.menuLevel:addButton(button)
    elseif levelName ~= 'mainmenu' then
      local button = TextButton('???')
      button.action = function() end
      self.menuLevel:addButton(button)
    end
  end

  -- Instructions menu
  self.menuInstructions = Menu(vector(self.instructionsPosition.x, 400))
  
  local instBackButton = TextButton('Back')
  instBackButton.action = function()
    self.camera.focus.x = self.mainPosition.x
    self.timer.add(0.1, function()
      self.menuActive = self.menuMain
    end)
  end
  self.menuInstructions:addButton(instBackButton)
  
  self.menuActive = self.menuMain
  
  self.background = BackgroundParallax(vector(self.level:getWidth(), self.level:getHeight()))
  for i, background in ipairs(self.level.backgrounds) do
    self.background:add(background)
  end

  if soundOn then
    music.title:setVolume(0.5)
    love.audio.play(music.title)
  end
end

function mainmenu.mousepressed(self, x, y, button)
  self.menuActive:mousepressed(vector(x, y))

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
  self.menuActive:mousereleased(vector(x, y))
end

function mainmenu.keypressed(self, key, unicode)
  self.menuActive:keypressed(key, unicode)

  if key == 'escape' then
    love.event.push('quit')
  end
  
  if key == 't' then
    if love.audio.getVolume() == 1 then
      love.audio.setVolume(0)
    else
      love.audio.setVolume(1)
    end
  end
end

function mainmenu.update(self, dt)
  if debug then
    self.log:update(dt)
    self.log:addLine(string.format('Camera: %i, %i', self.camera.position.x, self.camera.position.y))
    self.log:addLine(string.format('FPS: %s', tostring(love.timer.getFPS())))
  end
  
  input:update(dt)
  self.menuActive:update(dt)
  self.level:update(dt)
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

  self.menuMain:draw()
  self.menuLevel:draw()
  self.menuInstructions:draw()
  
  self.logo:draw()

  local instructions = "Use the Arrow keys or WSAD to move.\nPress Z to jump.\nDon't get crushed by falling blocks.\nDon't fall to your doom.\nDon't fear change.\nDon't worry that you'll never amount to anything.\nDon't.Stop."

  colors.darkest:set()
  love.graphics.printf(instructions, 1151, 101, 500)
  colors.lightest:set()
  love.graphics.printf(instructions, 1150, 100, 500)

  local soundStatus = 'ON'
  if love.audio.getVolume() == 0 then
    soundStatus = 'OFF'
  end
  
  local soundPrompt = string.format('(T)oggle sound: %s', soundStatus)
  love.graphics.setFont(fonts.tiny)
  colors.darkest:set()
  love.graphics.print(soundPrompt, 31, 446)
  colors.lightest:set()
  love.graphics.print(soundPrompt, 30, 445)

  love.graphics.pop()
  
  if debug then
    self.log:draw()
  end
end

function mainmenu.leave(self)
  
end