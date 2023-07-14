Vec = require('libs/util/vector')
anim8 = require('libs/anim8')
binds = require('config').binds

Player = setmetatable({}, require('class'))
Player.__index = Player


function Player.new(name)
    local self = setmetatable({}, Player)
    self.pos = Vec(0, 0)
    self.speed = 69000
    self.turnSpeed = 90000
    self.r = 0
    self.name = name

    return self
end

function Player:load(owner, world)
    self.owner = owner
    self.src = love.graphics.newImage("assets/player/space-ship-v1.png")
    self.srcSize = Vec(self.src:getWidth(), self.src:getHeight())
    self.w, self.h = 32, 32
    w, h = self.w, self.h
    local g = anim8.newGrid(32, 32, self.srcSize.x, self.srcSize.y)
    self.animations =  anim8.newAnimation(g('1-2',1), 0.1)

    self.body = love.physics.newBody(world, 10, 10, "dynamic")
    -- self.body:setFixedRotation(true)
    self.body:setMass(1000)
    self.body:setLinearDamping( 0.2 )
    self.body:setAngularDamping( 0.7 )

    self.shape = love.physics.newPolygonShape(0,0, w, 0, w, h, 0, h)
    self.fixture = love.physics.newFixture( self.body, self.shape)

    self.body:setAngle(0)

    table.insert(owner.level.map.box2d_collision, self)
    -- self.body:setAngularVelocity( 0.9 )
end

function Player:draw()
    -- love.graphics.draw(self.src, self.pos.x, self.pos.y, 0, 2, nil)
    -- love.graphics.draw(self.src, 50, 50, 0, 2)
    self.animations:draw(self.src, self.pos.x, self.pos.y, self.body:getAngle(), nil, nil)--, self.w*0.25, self.h*0.5)
    love.graphics.points( self.body:getPosition() )
end

function Player:update(dt)
    self:move(dt)
    self.pos = Vec(self.body:getPosition())-- + Vec(self.w*0.25, self.h*0.5)
    
    self.animations:update(dt)
end

function Player:move(dt)
    x, y = self.body:getPosition()
    if love.keyboard.isDown( binds.rotR ) then
        -- self.body:applyAngularImpulse(self.turnSpeed*dt)
        self.body:applyTorque(self.turnSpeed*dt)
    end
    if love.keyboard.isDown( binds.rotL ) then
        -- self.body:applyAngularImpulse(-self.turnSpeed*dt)
        self.body:applyTorque(-self.turnSpeed*dt)
    end
    if love.keyboard.isDown( binds.rocket ) then
        impulse = Vec(self.speed, 0)
        impulse = impulse:rotated(self.body:getAngle())
        self.body:applyForce(impulse.x*dt, impulse.y*dt)
    end
end

function Player:getCenter()
    diff = Vec(self.w*0.5, self.h*0.5)
    diff:rotateInplace(self.body:getAngle())
    return self.pos + diff
end

return Player("Bob")