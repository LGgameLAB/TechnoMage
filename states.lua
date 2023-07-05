State = setmetatable({
    color = {0, 0, 0}
}, require('class'))
State.__index = State

function State.new(owner, tbl)
    local self = setmetatable(tbl or {}, State)
    self.owner = owner
    self.active = false
    self.paused = false
    return self
end
function State:load()
end
function State:activate()
    self.active = true
    self:load()
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

Button = require('ui').button
mainMenu = State({
    bigBtn = Button(20, 80, 60, 20, "hello"),
    img1 = love.graphics.newImage('assets/payaso.jpg')
})
function mainMenu.load()
end
function mainMenu:update(dt)
    self.bigBtn:update(dt)
end
function mainMenu:render()
    State:render()
    self.bigBtn:draw()
    w, h, v = love.window.getMode()
    love.graphics.setColor(1,1,1)
    love.graphics.print(string.format("Width: %.1f | Height: %.1f", w, h), 22,22)
    love.graphics.draw(self.img1, 250, 0)
end

mainLoop = State()
return {mainMenu}