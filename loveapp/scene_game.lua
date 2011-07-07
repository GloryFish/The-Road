-- 
--  scene_game.lua
--  desert
--  
--  Created by Jay Roberts on 2011-01-06.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'logger'
require 'level'
require 'camera'
require 'player'
require 'vector'
require 'textfader'
require 'colors'

game = Gamestate.new()
game.level = ''

function game.enter(self, pre)
  self.log = Logger(vector(10, 10))
  self.log.color = colors.black
  
  self.camera = Camera()
  
  self.level = Level('test')
  
  self.player = Player(self.level.playerStart)
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
  if debug then
    self.log:update(dt)

    self.log:addLine(string.format('Level: %s', self.level.name))

    local mouse = vector(love.mouse.getX(), love.mouse.getY()) + self.camera.offset
    local tile = self.level:toTileCoords(mouse)
    local tileString = 'air'

    tile = tile + vector(1, 1)
  
    if self.level.tiles[tile.x] then
      tileString = self.level.tiles[tile.x][tile.y]
  
      if tileString == nil or tileString == ' ' then
        tileString = 'air'
      end
    end
  
  
    self.log:addLine(string.format('World: %i, %i', mouse.x, mouse.y))
    self.log:addLine(string.format('Tile: %i, %i, %s', tile.x, tile.y, tileString))
    if self.player.onground then
      self.log:addLine(string.format('State: %s', 'On Ground'))
    else
      self.log:addLine(string.format('State: %s', 'Jumping'))
    end
    self.log:addLine(string.format('Width: %i Height: %i', self.level:getWidth(), self.level:getHeight()))

    if (self.level:pointIsWalkable(mouse)) then
      self.log:addLine(string.format('Walkable'))
    else
      self.log:addLine(string.format('Wall'))
    end
  end
  
  self.level:update(dt)
  self.player:update(dt)
end

function game.draw(self)
  self.level:draw()
  self.player:draw()
  
  if debug then
    self.log:draw()
  end
end

function game.quit(self)
  love.event.push('q')
end

-- set unused objects to nil so they can be garbage collected
function game.leave(self)
end