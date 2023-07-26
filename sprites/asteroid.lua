Vector = require('libs/util/vector')

class = require('class')

Asteroid = class()
Asteroid:set(
    {
        -- image = love.graphics.newImage(''),
        size = {50, 50},
        speed = 50000
    }
)

function Asteroid:init(owner, physicsworld, x, y)
    self.body = love.physics.newBody(physicsworld, x, y, "dynamic")
    self.body:setMass(1000)
    self.vel = Vector.randomDirection(self.speed-10, self.speed+10)
    -- print(self.vel.x)
    self.body:applyLinearImpulse(self.vel.x, self.vel.y)
end

function Asteroid:update(dt)

end

function Asteroid:draw()
    local x, y = self.body:getPosition()
    love.graphics.circle('fill', x, y, self.size[1])
end

return {Asteroid=Asteroid}