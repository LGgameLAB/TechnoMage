game = require('game')()
require('settings')

function love.load()
    -- love.graphics.setBackgroundColor(1,1,1)
    print(love.graphics.getRendererInfo())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    game:load()
end

function love.draw()
    if CROSSHATCH then
        love.graphics.line(0, height*0.5, width, height*0.5)
        love.graphics.line(width*0.5, 0, width*0.5, height)
    end
    game:draw()
    love.graphics.print(love.timer.getFPS( ))
end

function love.update(dt)
    game:update(dt)
end