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
    w, h = self.w, self.h
    local g = anim8.newGrid(32, 32, self.w, self.h)
    self.animations =  anim8.newAnimation(g('1-2',1), 0.1)

    self.body = love.physics.newBody(world, 50, 50, "dynamic")
    -- self.body:setFixedRotation(true)
    self.body:setMass(1000)

    self.shape = love.physics.newPolygonShape(0,0, w*0.5, 0, w*0.5, h, 0, h)
    love.physics.newFixture( self.body, self.shape, 1 )

    self.body:setAngle(0)
    -- self.body:setAngularVelocity( 0.9 )
end

function Player:draw()
    -- love.graphics.draw(self.src, self.pos.x, self.pos.y, 0, 2, nil)
    -- love.graphics.draw(self.src, 50, 50, 0, 2)
    self.animations:draw(self.src, self.pos.x, self.pos.y, self.body:getAngle(), nil, nil, 16, 16)
end

function Player:update(dt)
    self:move(dt)
    self.pos = Vec(self.body:getPosition())
    
    self.animations:update(dt)
end

function Player:move(dt)
    x, y = self.body:getPosition()
    if love.keyboard.isDown( binds.rotR ) then
        -- self.body:applyAngularImpulse(self.turnSpeed*dt)
        self.body:applyTorque(self.turnSpeed*dt*999)
    end
    if love.keyboard.isDown( binds.rotL ) then
        -- self.body:applyAngularImpulse(-self.turnSpeed*dt)
    end
    if love.keyboard.isDown( binds.rocket ) then
        impulse = Vec(self.speed, 0)
        impulse = impulse:rotated(self.body:getAngle())
        self.body:applyLinearImpulse(impulse.x*dt, impulse.y*dt)
    end
end

return Player("Bob")