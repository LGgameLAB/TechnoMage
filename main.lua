moonshine = require 'libs/moonshine'

function love.load()
    states = require('states')
    current = states[2]
    current:activate()
    love.graphics.setBackgroundColor(1,1,1)
    effect = moonshine.chain(moonshine.effects.glow)
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
    love.graphics.reset()
    effect(function ()
    current:render()
    end
    )
    love.graphics.print(love.timer.getFPS( ))
end

function love.update(dt)
    current:update(dt)
end