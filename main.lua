scale = 1
shaders = require('libs/shaders')


function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setDefaultFilter("nearest", "nearest")
    states = require('states')
    current = states[2]
    current:activate()
    
    shaders:init()
    if shaders then
        shaders:refresh()
    end
    -- shaders:set(1, 'heavybloom')
    -- Old Shader Lib 
    -- effect = moonshine.chain(moonshine.effects.glow)
    -- effect.chain(moonshine.effects.crt)
    -- effect.chain(moonshine.effects.scanlines)
    -- effect.chain(moonshine.effects.gaussianblur)
    -- effect.crt.distortionFactor = {1.06, 1.065}
    -- effect.scanlines.width = 1
    -- effect.gaussianblur.sigma = 0.2

    love.window.setTitle("SPACE")
    
    -- w = love.window.getWidth()
end

function love.draw()
    -- love.graphics.reset()
    shaders:predraw()
    -- effect(function ()
    current:render()
    -- end
    -- )
    shaders:postdraw()
    love.graphics.print(love.timer.getFPS( ))
end

function love.update(dt)
    current:update(dt)
end