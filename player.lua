Vec = require('util').Vector2d

Player = setmetatable({}, require('class'))
Player.__index = Player


function Player.new(name)
    local self = setmetatable({}, Player)
    self.image = love.graphics.newImage("assets/player/space-ship-v1.png")
    self.pos = Vec(0, 0)
    self.r = 0
    self.name = name
    return self
end

function Player:load()
end

function Player:update(dt)
    self.pos.x = self.pos.x + 90*dt
end


return Player("Bob")