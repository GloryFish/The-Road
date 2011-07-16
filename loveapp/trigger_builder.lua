-- 
--  trigger_builder.lua
--  The-Road
--  
--  Created by Jay Roberts on 2011-07-09.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'vector'
require 'middleclass'

TriggerBuilder = class('TriggerBuilder')
function TriggerBuilder:initialize()
end

function TriggerBuilder:row(triggers, startX, endX, y, startTime, interval)
  local time = startTime

  local delta = 1
  if endX < startX then
    delta = -1
  end

  local count = 1
  for x = startX, endX, delta do
    local trigger = {
      position = vector(x, y) + vector(-1, -1),
      time = startTime + interval * count
    }
    table.insert(triggers, trigger)
    count = count + 1
  end
end

function TriggerBuilder:column(triggers, x, startY, endY, startTime, interval)
  local time = startTime

  local delta = 1
  if endY < startY then
    delta = -1
  end

  local count = 1
  for y = startY, endY, delta do
    local trigger = {
      position = vector(x, y) + vector(-1, -1),
      time = startTime + interval * count
    }
    table.insert(triggers, trigger)
    count = count + 1
  end
end