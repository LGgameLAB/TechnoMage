Bullet = setmetatable({
    image = love.graphics.newImage('assets/objects/bullet.png'),
    vel = 2500
}, require('class'))
Bullet.__index = Bullet

function Bullet.new(owner, x, y, ang)
    self = setmetatable({}, Bullet)
    -- This is one of the few objects where I will load the data on initiation
    self.owner = owner
    table.insert(self.owner.owner.level.spriteLayer.sprites, self)
    self.body = love.physics.newBody(game.state.physics, x, y, 'dynamic')
    self.body:setMass(4)
    self.shape = love.physics.newCircleShape(2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.angle = ang
    local dir = Vec(self.vel, 0):rotated(ang)
    self.body:applyForce(dir.x, dir.y)

    return self
end

function Bullet:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end

function Bullet:update(dt)
    local dir = Vec(self.vel, 0):rotated(self.angle)
    -- self.body:applyForce(dir.x, dir.y)
    self.body:getContacts()
    
end

return Bullet