scale = 1
shaders = require('libs/shaders')


function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(1920*0.5, 1080*0.5)
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
    
    width, height = love.window.getMode()
end

function love.draw()
    -- love.graphics.reset()
    shaders:predraw()
    -- effect(function ()
    current:render()
    love.graphics.line(0, height*0.5, width, height*0.5)
    love.graphics.line(width*0.5, 0, width*0.5, height)
    -- end
    -- )
    shaders:postdraw()
    love.graphics.print(love.timer.getFPS( ))
end

function love.update(dt)
    current:update(dt)
end