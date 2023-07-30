Vec = require('libs/util/vector')
Bullet = require('bullets')
anim8 = require('libs/anim8')
require('settings')

Player = class()

function Player:init(name)
    self.pos = Vec(0, 0)
    self.shape = love.physics.newPolygonShape(4, 8, 4, 24, 11, 24, 30, 15, 11, 8)
    self.speed = 19000*0.00416
    self.turnSpeed = 30000*0.00416
    self.w, self.h = 32, 32
    self.r = 0
    self.canShoot = true
    self.shootDelay = 0.2
    self.name = name
    self.shady = lg.newShader('libs/shaders/blcknwht.frag')
end

function Player:load(owner, world)
    self._identify = "player"
    self.owner = owner
    self.src = love.graphics.newImage("assets/player/space-ship-v1.png")
    self.srcSize = Vec(self.src:getWidth(), self.src:getHeight())
    self.w, self.h = 32, 32
    local w, h = self.w, self.h
    local g = anim8.newGrid(32, 32, self.srcSize.x, self.srcSize.y)
    self.animations =  anim8.newAnimation(g('1-2',1), 0.1)

    self.body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
    -- self.body:setFixedRotation(true)
    self.body:setMass(3000)
    self.body:setLinearDamping( 0.2 )
    self.body:setAngularDamping( 0.9 )

    -- self.shape = love.physics.newPolygonShape(0,0, w, 0, w, h, 0, h)
    self.fixture = love.physics.newFixture( self.body, self.shape)
    self.fixture:setCategory(1)

    self.body:setAngle(0)

    self.partSpeed = 300
    self.parts = love.graphics.newParticleSystem(love.graphics.newImage('assets/player/flame.png'), 100)
    self.parts:setParticleLifetime(0)
    self.parts:setEmissionRate(40)
    self.parts:setSizeVariation(0)
    self.parts:setSizes(1, 0.2)
    self.parts:setColors(1,1,1,1,0,0,0,0)

    self.hvyBloom = love.graphics.newShader('libs/shaders/heavybloom.frag')

    
    function love.keypressed(k)
        if k == 'return' then
            print('yay')
            owner.dialogue:pop()
          elseif k == 'c' then
            owner.dialogue:complete()
          elseif k == 'f' then
            owner.dialogue:faster()
        --   elseif k == 'down' then
        --     pcall(owner.dialogue:changeOption, 1) -- next one
        --   elseif k == 'up' then
        --     owner.dialogue:changeOption(-1) -- previous one
          end
    end
end

function Player:draw()
    -- love.graphics.draw(self.src, self.pos.x, self.pos.y, 0, 2, nil)
    -- love.graphics.draw(self.src, 50, 50, 0, 2)
    -- lg.setShader(self.shady)
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
    -- lg.setShader(nil)
    local diff = self:getCenter() + Vector(-self.w*0.5, 0):rotated(ang)
    lg.setShader(self.hvyBloom)
    love.graphics.draw(self.parts, diff.x, diff.y, 0, 1, 1, 0, 0)
    lg.setShader()
end

function Player:update(dt)
    self:move(dt)
    self:shoot()
    self.pos = Vec(self.body:getPosition())-- + Vec(self.w*0.25, self.h*0.5)

    self.animations:update(dt)
    self.parts:setLinearAcceleration(Vector(-self.partSpeed, 2):rotated(self.body:getAngle()):unpack())
    self.parts:setRotation(self.body:getAngle())
    self.parts:update(dt)
end

function Player:move(dt)
    local moving = false
    local x, y = self.body:getPosition()
    if love.keyboard.isDown( binds.rotR ) then
        -- self.body:applyAngularImpulse(self.turnSpeed*dt)
        self.body:applyTorque(self.turnSpeed)
    end
    if love.keyboard.isDown( binds.rotL ) then
        -- self.body:applyAngularImpulse(-self.turnSpeed*dt)
        self.body:applyTorque(-self.turnSpeed)
    end
    if love.keyboard.isDown( binds.rocket ) then
        impulse = Vec(self.speed, 0)
        impulse = impulse:rotated(self.body:getAngle())
        self.body:applyForce(impulse.x, impulse.y)
        moving = true
    end
    if love.keyboard.isDown( binds.reverseRocket ) then
        impulse = Vec(-self.speed, 0)
        impulse = impulse:rotated(self.body:getAngle())
        self.body:applyForce(impulse.x, impulse.y)
        -- moving = true
    end
    if moving and not ( Vector(self.body:getLinearVelocity()):len() < 20) then
        self.parts:start()
    else
        self.parts:stop()
    end
    self.parts:setParticleLifetime(Vector(self.body:getLinearVelocity()):len()/1000 + 0.4)
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
    local diff = Vec(self.w*0.5, self.h*0.5)
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