game = require('game')()

function love.load()
    love.debug = false
    game:load()
end

function love.draw()
    love.graphics.print(love.timer.getFPS( ))
    if love.debug then
        love.graphics.line(0, height*0.5, width, height*0.5)
        love.graphics.line(width*0.5, 0, width*0.5, height)
    end
    game:draw()
end

function love.update(dt)
    game:update(dt)
end