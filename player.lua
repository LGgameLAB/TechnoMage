Vec = require('libs/util/vector')
Bullet = require('bullets')
anim8 = require('libs/anim8')
require('settings')

Player = class()

function Player:init(name)
    self.pos = Vec(0, 0)
    self.speed = 69000
    self.turnSpeed = 290000
    self.r = 0
    self.canShoot = true
    self.shootDelay = 0.2
    self.name = name
end

function Player:load(owner, world)
    self.owner = owner
    self.src = love.graphics.newImage("assets/player/space-ship-v1.png")
    self.srcSize = Vec(self.src:getWidth(), self.src:getHeight())
    self.w, self.h = 32, 32
    w, h = self.w, self.h
    local g = anim8.newGrid(32, 32, self.srcSize.x, self.srcSize.y)
    self.animations =  anim8.newAnimation(g('1-2',1), 0.1)

    self.body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
    -- self.body:setFixedRotation(true)
    self.body:setMass(1000)
    self.body:setLinearDamping( 0.2 )
    self.body:setAngularDamping( 0.9 )

    self.shape = love.physics.newPolygonShape(0,0, w, 0, w, h, 0, h)
    self.fixture = love.physics.newFixture( self.body, self.shape)

    self.body:setAngle(0)

    table.insert(owner.level.map.box2d_collision, self)
    -- self.body:setAngularVelocity( 0.9 )
end

function Player:draw()
    -- love.graphics.draw(self.src, self.pos.x, self.pos.y, 0, 2, nil)
    -- love.graphics.draw(self.src, 50, 50, 0, 2)
    local ang = self.body:getAngle() % (math.pi*2)
    local scaley = 1
    local oy = 0
    if ang > math.pi*0.5 and ang < math.pi*1.5 then
        scaley = -1
        oy = self.w
    end
    self.animations:draw(self.src, self.pos.x, self.pos.y, ang, 1, scaley, 0, oy)--, self.w*0.25, self.h*0.5)
    if DEBUG then
        love.graphics.points( self.body:getPosition() )
    end
end

function Player:update(dt)
    self:move(dt)
    self:shoot()
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
    if love.keyboard.isDown( binds.reverseRocket ) then
        impulse = Vec(-self.speed, 0)
        impulse = impulse:rotated(self.body:getAngle())
        self.body:applyForce(impulse.x*dt, impulse.y*dt)
    end
end

function Player:shoot()
    if self.canShoot and love.keyboard.isDown( binds.shoot ) then
        local diff = Vec(self.w*0.75, 0)
        diff:rotateInplace(self.body:getAngle())
        local new = diff + self:getCenter()
        x, y = new:unpack() 
        Bullet(self, x, y, self.body:getAngle())
        self.canShoot = false
        game.timer.after(self.shootDelay, function ()
            self.canShoot = true
        end)
    end
end

function Player:getCenter()
    diff = Vec(self.w*0.5, self.h*0.5)
    diff:rotateInplace(self.body:getAngle())
    return self.pos + diff
end

function Player:setPos(x, y)
    if self.body then
        self.body:setPosition( x, y )
    else
        self.pos = Vec(x, y)
    end
end

return Player("Bob")