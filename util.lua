-- These only work with strings
function inArray(v, t)
    for i=1,#t do
      if v == t[i] then return true end
    end
end
function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

class = require('class')
Rect = class()

function Rect:init(x, y, w, h)
    self.x = x
    self.y = y
    self.width, self.w = w, w
    self.height, self.h = h, h
    self.pos = {x = x, y = y}
end

function Rect:getval(mode)
    if inArray(mode, { "r", "right"}) then
        return self.x + self.w
    elseif inArray(mode, { "l", "left"}) then
        return self.x
    elseif inArray(mode, {"u", "up", "top", "t"}) then
        return self.y
    elseif inArray(mode, {"d", "down", "bottom", "b"}) then
        return self.y + self.h
    elseif inArray(mode, {"center", "middle"}) then
        return {self.x+self.w*0.5, self.y +self.h*0.5}
    elseif inArray(mode, {"topleft", "origin", "o"}) then
        return self.x, self.y
    end
    
    error('Rect query mode not recognized')
end

function Rect:setCenter(x, y)
    self.x = x - self.width * 0.5
    self.y = y - self.height * 0.5
end

function Rect:collide(other)
    if self:getval('r') > other:getval('l')  and self:getval('l') < other:getval('r')
     and self:getval('t') < other:getval('b') and self:getval('b') > other:getval('t') then
        return true
    end
    return false
end

function Rect:move(x, y)
    return Rect(x, y, self.w, self.h)
end
-- Vector2d = setmetatable({}, require('class'))
-- Rect.__index = Rect

Vector2d = function(x, y)
    return {x=x, y=y}
end

return {Rect=Rect, inArray=inArray, Vector2d=Vector2d, indexOf=indexOf}