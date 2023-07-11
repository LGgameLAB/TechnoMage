-- These only work with strings
function inArray(v, t)
    for i=1,#t do
      if v == t[i] then return true end
    end
  end

Rect = setmetatable({}, require('class'))
Rect.__index = Rect

function Rect.new(x, y, w, h)
    local self = setmetatable({}, Rect)
    self.x = x
    self.y = y
    self.width, self.w = w, w
    self.height, self.h = h, h
    self.pos = {x = x, y = y}
    return self
end

function Rect:get(mode)
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
        return {self.x, self.y}
    end
    
    error('Rect query mode not recognized')
end

function Rect:collide(other)
    if self:get('r') > other:get('l')  and self:get('l') < other:get('r')
     and self:get('t') < other:get('b') and self:get('b') > other:get('t') then
        return true
    end
    return false
end

-- Vector2d = setmetatable({}, require('class'))
-- Rect.__index = Rect

Vector2d = function(x, y)
    return {x=x, y=y}
end

return {Rect=Rect, inArray=inArray, Vector2d=Vector2d}