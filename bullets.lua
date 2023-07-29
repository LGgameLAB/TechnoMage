util = require('util')

Bullet = require('sprite'):extend()
Bullet:set({
    image = love.graphics.newImage('assets/objects/bullet.png'),
    vel = 2500
})

function Bullet:init(owner, x, y, ang)
    -- This is one of the few objects where I will load the data on initiation
    self._identify = "bullet"
    self.owner = owner 
    self.super().load(self, {'Sprite Layer'})
    self.body = love.physics.newBody(game.state.physics, x, y, 'dynamic')
    self.body:setMass(4)
    self.body:setBullet(true)
    self.shape = love.physics.newCircleShape(2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    -- self.fixture:setMask(1)
    self.angle = ang
    local dir = Vec(self.vel, 0):rotated(ang)
    self.body:applyForce(dir.x, dir.y)
end

function Bullet:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end

function Bullet:update(dt)
    local dir = Vec(self.vel, 0):rotated(self.angle)
    -- self.body:applyForce(dir.x, dir.y)
    if self.body:isActive() then
        for _, c in pairs(self.body:getContacts()) do
            -- local cpos = {c:getPositions( )}
            -- cpos[1])
            if c:isTouching( ) then
                local one, two = c:getFixtures()
                if one:getGroupIndex( ) == 300 then
                    -- self.body:setPosition(x, y)
                    -- self.body:setActive( false )
                    self.super().kill(self)
                    self.super().kill(self)
                    -- self.body:setActive(false)
                    -- self.fixture:destroy()
                    break
                end
            end
        end
    end
end

return Bullet