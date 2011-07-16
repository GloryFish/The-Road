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
require 'fader'

game = Gamestate.new()
game.level = nil

function game.enter(self, pre)
  self.log = Logger(vector(10, 10))
  self.log.color = colors.white
  
  if self.level == nil then
    self.level = Level('level-1')
  end
  self.player = Player(self.level.playerStart)

  self.camera = Camera()
  self.camera.bounds = {
    top = 0,
    right = math.max(self.level:getWidth(), love.graphics.getWidth()),
    bottom = math.max(self.level:getHeight(), love.graphics.getHeight()),
    left = 0
  }
  self.camera.position = self.player.position:clone()
  self.camera:update(0)

  self.fader = Fader()
  self.fader.maxduration = 1.5
  self.fader.color = colors.lightest

  self.goalReached = false
  self.attemptElapsed = 0 -- Total time taken for the current attempt, resets to zero on death or reset()
  
  self.timer = require 'timer'
end

function game.reset(self)
  self.level:reset()
  self.player:reset()
  self.player.position = self.level.playerStart:clone()
  self.camera.position = self.level.playerStart:clone()
  self.camera.bounds = {
    top = 0,
    right = self.level:getWidth(),
    bottom = self.level:getHeight(),
    left = 0
  }
  self.goalReached = false
  self.attemptElapsed = 0
  self.fader:fadeIn()
end

function game.keypressed(self, key, unicode)
  if key == 'escape' then
    self:quit()
  end
  
  if debug and key == 'r' then
    self:reset()
  end

  if debug and key == 'f' then
    self.fader:fadeIn()
  end

end

function game.mousepressed(self, x, y, button)
  if debug then
    local mouseWorldPoint = vector(x, y) + self.camera.offset
    
    if button == 'l' then
      self.level:activateBlockAtWorldCoords(mouseWorldPoint)
    end
    if button == 'r' then
      self.level:dropGoal()
    end
  end
end

function game.mousereleased(self, x, y, button)
end

function game.update(self, dt)
  self.attemptElapsed = self.attemptElapsed + dt
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
    self.log:addLine(string.format('State: %s', self.player.animation.current))

    -- self.log:addLine(string.format('Width: %i Height: %i', self.level:getWidth(), self.level:getHeight()))

    -- if (self.level:pointIsWalkable(mouse)) then
    --   self.log:addLine(string.format('Walkable'))
    -- else
    --   self.log:addLine(string.format('Wall'))
    -- end

    -- self.log:addLine(string.format('Active: %i', #self.level.blockManager.blocks))

    -- self.log:addLine(string.format('Player animation: %s', self.player.animation.current))
    -- self.log:addLine(string.format('Player velocity: %s', tostring(self.player.velocity)))

    -- self.log:addLine(string.format('Goal: %f', self.player.position:dist(self.level.goal)))
    
    -- if self.goalReached then
    --   self.log:addLine('GOAL!!!!!!')
    -- end
    self.log:addLine(string.format("Time: %i:%02d", self.attemptElapsed / 60, self.attemptElapsed % 60))




    self.log:addLine(string.format('Press R to reset.'))

  end
  
  self.fader:update(dt)
  
  input:update(dt)
  self.level:update(dt)
  
  if not self.player.dead and not self.goalReached then
    self.player:setMovement(input.state.movement)

    if input.state.buttons.newpress.jump then
      if self.player.onground then
        self.player:jump()
      end
    end 
  end
  
  -- Apply gravity
  local gravityAmount = 1

  if input.state.buttons.jump and self.player.velocity.y < 0 and not self.player.dead then
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
    else
      self.player.onground = false
      if not self.player.dead then
        self.player:setAnimation('falling')
      end
    end
  end

  -- We are going to use these upper coordinates in two separate checks
  local testUL = vector(curUL.x, newUL.y)
  local testUR = vector(curUR.x, newUR.y)

  if not self.player.dead and (self.level:pointIsLethal(testUL) or self.level:pointIsLethal(testUR)) then -- Kill player
    self.player:kill()
    self.fader:fadeOut()
    self.timer.add(self.fader.maxduration, function() self:reset() end)
  end

  -- If we survived that, then we can check for a jumping collision against somethign that's non-walkable
  if self.player.velocity.y < 0 then -- Jumping

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

  -- If we've reached the goal, dampen horizontal movement
  if self.goalReached then
    self.player.velocity.x = self.player.velocity.x * 0.9
  end

  -- Here we update the player, the final velocity will be applied here
  self.player:update(dt)

  -- Check to see if player has fallen below the bounds
  if self.player.position.y > self.level:getHeight() then
    if self.goalReached then -- Next level!
      -- Next level
      self.level = Level(self.level.nextLevelName)
      self:reset()
    elseif not self.player.dead then -- Kill him
      self.player:kill()
      self.fader:fadeOut()
      self.timer.add(self.fader.maxduration, function() self:reset() end)
    end
  end

  if self.level:pointIsAtGoal(self.player.position) then
    self.goalReached = true
    self.level:dropGoal()
  end

  if not self.goalReached then
    self.camera.focus = self.player.position
  end
  self.camera:update(dt)
  
end

function game.draw(self)
  local overlayCount = #self.level.backgrounds
  local maxOverlayMovement = 0.75
  
  for i, background in ipairs(self.level.backgrounds) do
    love.graphics.push()
    love.graphics.translate(-self.camera.offset.x * maxOverlayMovement / overlayCount * i, -self.camera.offset.y * maxOverlayMovement / overlayCount * i)
    love.graphics.draw(background, 0, 0, 0, 4, 4)
    love.graphics.pop()
  end
  
  love.graphics.push()

  -- Game
  love.graphics.translate(-self.camera.offset.x, -self.camera.offset.y)
  self.level:draw()
  self.player:draw()

  love.graphics.pop()
  
  love.graphics.translate(0, 0)  

  self.fader:draw()

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