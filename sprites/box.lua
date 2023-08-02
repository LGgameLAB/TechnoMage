util = require('util')
Vec = require('libs/util/vector')
fx = require('fx')

Box = require('sprite'):extend()
Box:set({
    image = love.graphics.newImage('assets/objects/crate.png'),

})

function Box:init(owner, tiledObj)
    self.tiledObj = tiledObj
    -- self.super().load(self, {'Sprite Layer'})
    self.super().addLayers(self, {'Sprite Layer'})
    self:load()
    
    print(#self.layers)
end

function Box:load()
    self.pos = Vec(self.tiledObj.x, self.tiledObj.y)
    self.body = lp.newBody(game.state.physics, self.tiledObj.x, self.tiledObj.y, "dynamic")
    self.shape = lp.newCircleShape(self.image:getWidth()/2)
    self.fixture = lp.newFixture(self.body, self.shape, 1)
    self.fixture:setGroupIndex(297)


    -- self.fx = fx(10, 10)
    -- self.fx:add({})
end

function Box:update()
    self.pos = Vector(self.body:getX(), self.body:getY())
end

function Box:draw()
    lg.draw(self.image, self.body:getX(), self.body:getY())
    if DEBUG then
        love.graphics.circle('line', self.pos.x, self.pos.y, self.shape:getRadius())
    end
end

return {Box = Box}