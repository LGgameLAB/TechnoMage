State = setmetatable({
    color = {0, 0, 0}
}, require('class'))
State.__index = State

function State.new()
    local self = setmetatable({}, State)
    self.active = false
    self.paused = false
    return self
end

function State:update(dt)
    self.runEvents()
end
function State:runEvents()
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end

end
function State:render()
end

mainMenu = State()

function mainMenu:render()
    State:render()
    w, h, v = love.window.getMode()
    love.graphics.print(string.format("Width: %.1f | Height: %.1f", w, h), 22,22)
end

return {mainMenu}