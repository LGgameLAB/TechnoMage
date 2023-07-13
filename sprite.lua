Vec = require 'libs/util/vector'
anim8 = require 'libs/anim8'

Sprite = setmetatable({}, require('class'))
Sprite.__index = Sprite

function Sprite.new()
    local self = setmetatable({}, Sprite)

    self.pos = Vec(0, 0)
    return self
end

function Sprite:load()    
end

function Sprite:draw()
end

function Sprite:update()
end