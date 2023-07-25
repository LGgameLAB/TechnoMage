util = require('util')

Enemy = require('sprite'):extend()
Enemy:set({
    image = love.graphics.newImage('assets/enemies/ugly.png'),
})

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

return {Enemy}