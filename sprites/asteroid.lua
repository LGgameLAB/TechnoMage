Vector = require('libs/util/vector')

sprite = require('sprite')

Asteroid = sprite:extend()
Asteroid:set(
    {
        img1 = love.graphics.newImage('assets/objects/big rock.png'),
        img2 = love.graphics.newImage('assets/objects/big rock2.png'),
        skeleton = {
            { x = 0, y = 0 },
            { x = -3, y = 13 },
            { x = 40, y = 41 },
            { x = 49, y = 41 },
            { x = 60, y = 17 },
            { x = 53, y = 0 },
            { x = 27, y = -8 },
            { x = 13, y = 0 }
        },
        skeleton2 = {
            { x = 0, y = 0 },
            { x = -11, y = 10 },
            { x = -11, y = 21 },
            { x = -18, y = 30 },
            { x = 6, y = 56 },
            { x = 30, y = 46 },
            { x = 24, y = 28 },
            { x = 29, y = 10 }
        },
        size = {50, 50},
        speed = 50
    }
)

function Asteroid:init(owner, physicsworld, x, y, layers)
    self.super().load(self, layers)
    self.body = love.physics.newBody(physicsworld, x, y, "dynamic")
    self.body:setMass(1000)

    self.scale = math.random()*0.4+1

    if math.random() < 0.5 then
        self.image = self.img1
        skel = self.skeleton
        self.type = 1
    else
        self.image = self.img2
        skel = self.skeleton2
        self.type = 2
    end
    local verts = {}
    for _, v in pairs(skel) do
        table.insert(verts, v.x*self.scale)
        table.insert(verts, v.y*self.scale)
    end 
    self.shape = love.physics.newPolygonShape(verts)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setGroupIndex(300)

    self.body:setAngle(math.random()*6.28)
    self.vel = Vector.randomDirection(self.speed-10, self.speed+10)
    -- print(self.vel.x)
    self.body:applyLinearImpulse(self.vel.x, self.vel.y)


end

function Asteroid:update(dt)

end

function Asteroid:draw()
    local x, y = self.body:getPosition()
    -- love.graphics.circle('fill', x, y, self.size[1])
    if self.type == 1 then
        love.graphics.draw(self.image, x, y, self.body:getAngle(), self.scale, nil, 0, 16)
    else
        love.graphics.draw(self.image, x, y, self.body:getAngle(), self.scale, nil, 26, 7)
    end
end

return {Asteroid=Asteroid}