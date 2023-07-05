moonshine = require 'moonshine'

function love.load()
    states = require('states')
    current = states[1]
    love.graphics.setBackgroundColor(1,1,1)
    effect = moonshine.chain(moonshine.effects.scanlines)
    effect.chain(moonshine.effects.crt)
    effect.chain(moonshine.effects.glow)
    effect.crt.distortionFactor = {1.06, 1.065}
    love.window.setTitle("TechnoMage")
    -- w = love.window.getWidth()
end

function love.draw()
    love.graphics.reset()
    effect(function ()
    current:render()
    end
    )
end

function love.update(dt)
    current:update(dt)
end