-- 
--  text_typer.lua
--  The-Road
--
--  Types out the supplied text then continually blinks the cursor
--  
--  Created by Jay Roberts on 2011-07-16.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'middleclass'
require 'vector'
require 'colors'

TextTyper = class('TextTyper')

function TextTyper:initialize(text, font, pos, rate, color, cursor)
  self.text     = text
  self.font     = font
  self.position = pos or vector(0, 0)
  self.rate     = rate or 5
  self.color    = color or colors.white
  self.cursor   = cursor or ''
  self.duration  = 0
end

function TextTyper:update(dt)
  self.duration = self.duration + dt
end

function TextTyper:draw(dt)
  love.graphics.setFont(self.font)
  

  colors.darkest:set()
  love.graphics.print(self:getText(), 
                      self.position.x + 1, 
                      self.position.y + 1);

  self.color:set()

  love.graphics.print(self:getText(), 
                      self.position.x, 
                      self.position.y);
end

function TextTyper:getText()
  chars = math.floor(self.duration * self.rate)
  if chars > string.len(self.text) then
    chars = string.len(self.text)
  end
  
  text = string.sub(self.text, 1, chars)

  local int, frac = math.modf(self.duration * 1) -- Adjust the final constant to change the blink speed of the cursor
  
  if (chars < string.len(self.text) or frac < 0.5) then
    text = text .. self.cursor
  end
  
  return text
end