util = require('util')
Vec = require('libs/util/vector')
fx = require('fx')
-- sprite = 
Enemy = require('sprite'):extend()
Enemy:set({
    image = love.graphics.newImage('assets/enemies/ugly.png'),
    health = 10
})

--This is another entity that sort of initiates and loads at the same time
function Enemy:init(owner, tiledObj)
    self.tiledObj = tiledObj
    -- self.super().load(self, {'Sprite Layer'})
    self.super().addLayers(self, {'Sprite Layer'})
    self:load()
    
    print(#self.layers)
end

-- function Enemy:load()
--     self.body = nil
-- end

function Enemy:draw()
end

function Enemy:update(dt)
    if self.health <= 0 then
        self.super().kill(self)
    end
end

function Enemy:takeDamage(dmg)
    self.health = self.health-dmg
end

Goober = Enemy:extend()
Goober:set({
    image = love.graphics.newImage('assets/enemies/ugly.png'),
    speed = 40,
    health = 5
})

function Goober:load()
    self.body = lp.newBody(game.state.physics, self.tiledObj.x, self.tiledObj.y, "dynamic")
    self.shape = lp.newCircleShape(self.image:getWidth()/2)
    self.fixture = lp.newFixture(self.body, self.shape, 1)
    self.fixture:setGroupIndex(299)

    self.fx = fx(10, 10)
    self.fx:add({})
end

function Goober:update(dt)
    local target = game.state.player:getCenter() - Vec(self.body:getWorldCenter())
    local target = target:normalized()*self.speed
    self.body:setLinearVelocity(target:unpack())
    if self.body:isActive() then
        for _, c in pairs(self.body:getContacts()) do
            if c:isTouching( ) then
                local one, two = c:getFixtures()
                if (one:getGroupIndex( ) == 298) or (two:getGroupIndex() == 298) then
                    
                    self:takeDamage(game.state.player:damage())
                end
            end
        end
    end

    self.fx:update(dt)
    if self.health <= 0 then
        
        self.super().kill(self)
    end

end

function Goober:draw()
    local offset = self.shape:getRadius()+(0.171572875254)
    self.fx:draw(function()
        lg.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), nil, nil, offset, offset)
    end)
    if DEBUG then
        love.graphics.circle('line', self.body:getX(), self.body:getY(),self.shape:getRadius())
    end
end
return {Enemy=Enemy, Goober=Goober}