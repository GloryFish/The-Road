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
  
  self.level = Level('test')
  self.player = Player(self.level.playerStart)

  self.camera = Camera()
  self.camera.bounds = {
    top = 0,
    right = math.max(self.level:getWidth(), love.graphics.getWidth()),
    bottom = math.max(self.level:getHeight(), love.graphics.getHeight()),
    left = 0
  }
  self.camera.position = self.player.position
  self.camera:update(0)
end

function game.keypressed(self, key, unicode)
  if key == 'escape' then
    self:quit()
  end
end

function game.mousepressed(self, x, y, button)
  if debug then
    local mouseWorldPoint = vector(x, y) + self.camera.offset
    self.level:activateBlockAtWorldCoords(mouseWorldPoint)
  end
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
    
    self.log:addLine(string.format('Player velocity: %s', tostring(self.player.velocity)))
  end
  
  input:update(dt)
  self.level:update(dt)
  
  self.player:setMovement(input.state.movement)

  if input.state.buttons.newpress.jump then
    if self.player.onground then
      self.player:jump()
    end
  end
  
  -- Apply gravity
  local gravityAmount = 1
  
  if input.state.buttons.jump and self.player.velocity.y < 0 then
    gravityAmount = 0.5
  end
  
  self.player.velocity = self.player.velocity + self.level.gravity * dt * gravityAmount -- Gravity
  
  if dt > 0.5 then
    self.player.velocity.y = 0
  end
  
  local newPos = self.player.position + self.player.velocity * dt
  local curUL, curUR, curBL, curBR = self.player:getCorners()
  local newUL, newUR, newBL, newBR = self.player:getCorners(newPos)
  
  if self.player.velocity.y > 0 then -- Falling
    local testBL = vector(curBL.x, newBL.y)
    local testBR = vector(curBR.x, newBR.y)
    
    if self.level:pointIsWalkable(testBL) == false or self.level:pointIsWalkable(testBR) == false then -- Collide with bottom
      self.player:setFloorPosition(self.level:floorPosition(testBL))
      self.player.velocity.y = 0
      self.player.onground = true
    end
  end

  if self.player.velocity.y < 0 then -- Jumping
    local testUL = vector(curUL.x, newUL.y)
    local testUR = vector(curUR.x, newUR.y)

    if self.level:pointIsWalkable(testUL) == false or self.level:pointIsWalkable(testUR) == false then -- Collide with top
      self.player.velocity.y = 0
    end
  end
  
  newPos = self.player.position + self.player.velocity * dt
  curUL, curUR, curBL, curBR = self.player:getCorners()
  newUL, newUR, newBL, newBR = self.player:getCorners(newPos)
  
  if self.player.velocity.x > 0 then -- Collide with right side
    local testUR = vector(newUR.x, curUR.y)
    local testBR = vector(newBR.x, curBR.y - 1)

    if self.level:pointIsWalkable(testUR) == false or self.level:pointIsWalkable(testBR) == false then
      self.player.velocity.x = 0
    end
  end

  if self.player.velocity.x < 0 then -- Collide with left side
    local testUL = vector(newUL.x, curUL.y)
    local testBL = vector(newBL.x, curBL.y - 1)

    if self.level:pointIsWalkable(testUL) == false or self.level:pointIsWalkable(testBL) == false then
      self.player.velocity.x = 0
    end
  end
  
  
  -- Here we update the player, the final velocity will be applied here
  self.player:update(dt)

  self.camera.focus = self.player.position
  self.camera:update(dt)
  
end

function game.draw(self)
  love.graphics.push()

  -- Game
  love.graphics.translate(-self.camera.offset.x, -self.camera.offset.y)
  self.level:draw()
  self.player:draw()

  love.graphics.pop()
  
  love.graphics.translate(0, 0)  

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