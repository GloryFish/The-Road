-- 
--  level.lua
--  redditgamejam-05
--  
--  Created by Jay Roberts on 2011-01-02.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'vector'
require 'tableextras'
require 'block_manager'

Level = class('Level')
function Level:initialize(name)

  self.scale = 1
  self.name = name
  
  -- Load a map file which will give us a tileset image, 
  -- a set of quads for each image in the tileset indexed by
  -- an ascii character, a string representing the initial level layout,
  -- and the size of each tile in the tileset.
  self.tileset, self.quads, self.tileString, self.tileSize, self.gravity, self.solid = love.filesystem.load(string.format('resources/maps/%s.lua', name))()

  -- Now we build an array of characters from the tileString
  self.tiles = {}
  self.enemyStarts = {}
  
  local width = #(self.tileString:match("[^\n]+"))

  for x = 1, width, 1 do 
    self.tiles[x] = {} 
  end

  local x, y = 1, 1
  
  self.pickupSpawns = {}

  for row in self.tileString:gmatch("[^\n]+") do
    assert(#row == width, 'Map is not aligned: width of row ' .. tostring(y) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
    x = 1
    for character in row:gmatch(".") do
      
      -- Handle player start
      if character == 'S' then
        self:setPlayerStart(x, y)
        self.tiles[x][y] = ' '
      elseif character == 'G' then
        self:setGoal(x, y)
        self.tiles[x][y] = 'G'
      else  
        self.tiles[x][y] = character
      end
      x = x + 1
    end
    y = y + 1
  end
  
  self.blockManager = BlockManager(self)
  self.blockManager.blockSize = self.tileSize
  self.blockManager.scale = self.scale
end

function Level:activateBlockAtWorldCoords(point)
  local tilePoint = self:toTileCoords(point) + vector(1, 1)
  
  if self.tiles[tilePoint.x] ~= nil then
    if table.contains(self.solid, self.tiles[tilePoint.x][tilePoint.y]) then
      self.tiles[tilePoint.x][tilePoint.y] = ' '

      -- Get the world coordinates of the upper left coordinate of the selected tile
      local worldPoint = self:toWorldCoords(tilePoint)
      self.blockManager:addBlock(worldPoint)  
    end
  end
end

function Level:setPlayerStart(x, y)
  -- playerStart should be placed in the center of the tile so we need to offset the world coordinates by half tileSize
  local coords = self:toWorldCoords(vector(x, y))
  self.playerStart = coords + vector(math.floor(self.tileSize * self.scale / 2), math.floor(self.tileSize * self.scale / 2))
end

function Level:setGoal(x, y)
  self.goal = vector(x, y)
end

function Level:setPlayerStart(x, y)
  -- playerStart should be placed in the center of the tile so we need to offset the world coordinates by half tileSize
  local coords = self:toWorldCoords(vector(x, y))
  self.playerStart = coords + vector(math.floor(self.tileSize * self.scale / 2), math.floor(self.tileSize * self.scale / 2))
end

function Level:update(dt)
  self.blockManager:update(dt)
end


function Level:draw()
  love.graphics.setColor(255, 255, 255, 255)
  for x, column in ipairs(self.tiles) do
    for y, char in ipairs(column) do
      love.graphics.drawq(self.tileset,
                          self.quads[char], 
                          (x - 1) * self.tileSize * self.scale, 
                          (y - 1) * self.tileSize * self.scale,
                          0,
                          self.scale,
                          self.scale)
    end
  end
  
  self.blockManager:draw()
end

function Level:getWidth()
  return #self.tiles * self.tileSize * self.scale
end

function Level:getHeight()
  return #self.tiles[1] * self.tileSize * self.scale
end

function Level:pointIsWalkable(point)
  local tilePoint = self:toTileCoords(point)
  tilePoint = tilePoint + vector(1, 1)
  
  -- Check static tiles for collision
  if self.tiles[tilePoint.x] ~= nil then
    if table.contains(self.solid, self.tiles[tilePoint.x][tilePoint.y]) then
      return false
    end
  end

  -- Check active blocks for collision
  return self.blockManager:pointIsWalkable(point) 
end

function Level:tilePointIsWalkable(tilePoint)
  tilePoint = tilePoint + vector(1, 1)
  
  if self.tiles[tilePoint.x] ~= nil then
    return not table.contains(self.solid, self.tiles[tilePoint.x][tilePoint.y])
  end
  
  return true
end

-- This function takes a world point returns the Y position of the top edge of the matching tile in world space
function Level:floorPosition(point)
  local y = math.floor(point.y / (self.tileSize * self.scale))
  
  return y * (self.tileSize * self.scale)
end

function Level:toWorldCoords(point)
  local world = vector(
    (point.x - 1) * self.tileSize * self.scale,
    (point.y - 1) * self.tileSize * self.scale
  )
  
  return world
end

function Level:toWorldCoordsCenter(point)
  local world = vector(
    point.x * self.tileSize * self.scale,
    point.y * self.tileSize * self.scale
  )
  
  world = world + vector(self.tileSize * self.scale / 2, self.tileSize * self.scale / 2)
  
  return world
end


function Level:toTileCoords(point)
  local coords = vector(math.floor(point.x / (self.tileSize * self.scale)),
                        math.floor(point.y / (self.tileSize * self.scale)))

  return coords
end

