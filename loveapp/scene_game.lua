-- 
--  scene_game.lua
--  desert
--  
--  Created by Jay Roberts on 2011-01-06.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'logger'
require 'level'
require 'vector'
require 'textfader'
require 'colors'

game = Gamestate.new()
game.level = ''

function game.enter(self, pre)
  self.log = Logger(vector(10, 10))
  self.log.color = colors.black
  
  self.level = Level('test')
  
end

function game.keypressed(self, key, unicode)
  if key == 'escape' then
    self:quit()
  end
end

function game.mousepressed(self, x, y, button)
end

function game.mousereleased(self, x, y, button)
end

function game.update(self, dt)
  self.log:update(dt)
  self.log:addLine(string.format('Level: %s', self.level.name))
  
  self.level:update(dt)
end

function game.draw(self)
  self.level:draw()
  self.log:draw()
end

function game.quit(self)
  love.event.push('q')
end

-- set unused objects to nil so they can be garbage collected
function game.leave(self)
end