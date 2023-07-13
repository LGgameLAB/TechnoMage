Vec = require('libs/util/vector')
anim8 = require('libs/anim8')
binds = require('config').binds

Player = setmetatable({}, require('class'))
Player.__index = Player


function Player.new(name)
    local self = setmetatable({}, Player)
    self.pos = Vec(0, 0)
    self.speed = 90
    self.turnSpeed = 90
    self.r = 0
    self.name = name

    return self
end

function Player:load(world)
    self.src = love.graphics.newImage("assets/player/space-ship-v1.png")
    self.w, self.h = self.src:getWidth(), self.src:getHeight()
    local g = anim8.newGrid(32, 32, self.w, self.h)
    self.animations =  anim8.newAnimation(g('1-2',1), 0.1)

    self.body = love.physics.newBody(world, 50, 50, "dynamic")
    self.body:setAngle(0.1)
    self.body:setAngularVelocity( 0.9 )
end

function Player:draw()
    
    self.animations:draw(self.src, self.pos.x, self.pos.y, self.body:getAngle())
end

function Player:update(dt)
    self:move(dt)
    self.pos = Vec(self.body:getPosition())
    
    self.animations:update(dt)
end

function Player:move(dt)
    x, y = self.body:getPosition()
    if love.keyboard.isDown( binds.rocket ) then
        self.body:applyLinearImpulse(self.speed*dt, 0, x, y+self.h*0.5+1)
    end
    if love.keyboard.isDown( binds.rotR ) then
        -- self.body:applyAngularImpulse(self.turnSpeed*dt)
        self.body:applyTorque(self.turnSpeed*dt*999)
    end
    if love.keyboard.isDown( binds.rotL ) then
        self.body:applyAngularImpulse(-self.turnSpeed*dt)
    end
end

return Player("Bob")