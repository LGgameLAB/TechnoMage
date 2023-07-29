util = require('util')
Vec = require('libs/util/vector')

Enemy = require('sprite'):extend()
Enemy:set({
    image = love.graphics.newImage('assets/enemies/ugly.png'),
})

--This is another entity that sort of initiates and loads at the same time
function Enemy:init(owner, tiledObj)
    self.tiledObj = tiledObj
    self.super().load(self, {'Sprite Layer'})
    self:load()
end

function Enemy:load()
    self.body = nil
end

function Enemy:draw()
end

Goober = Enemy:extend()
Goober:set({
    image = love.graphics.newImage('assets/enemies/ugly.png'),
    speed = 400
})

function Goober:load()
    self.body = lp.newBody(game.state.physics, self.tiledObj.x, self.tiledObj.y, "dynamic")
    self.shape = lp.newCircleShape(self.image:getWidth()/2)
    self.fixture = lp.newFixture(self.body, self.shape, 1)
end

function Goober:update(dt)
    local target = game.state.player:getCenter() - Vec(self.body:getWorldCenter())
    local target = target:normalized()*self.speed
    self.body:setLinearVelocity(target:unpack())

end

function Goober:draw()
    local offset = self.shape:getRadius()+(0.171572875254)
    lg.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), nil, nil, offset, offset)
    love.graphics.circle('line', self.body:getX(), self.body:getY(),self.shape:getRadius())
    -- print("GOBBER")
end
return {Enemy=Enemy, Goober=Goober}