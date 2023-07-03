function love.load()
    states = require('states')
    current = states[1]
    love.window.setTitle("TechnoMage")
    -- w = love.window.getWidth()
end

function love.draw()
    current:render()
end

function love.update(dt)
    current:update(dt)
end