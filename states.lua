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

 
Button = require('ui').Button
-- This is where we define our Menu Scene
mainMenu = State()

function mainMenu:load()
    self.bigBtn = Button(self.owner, 20, 80, 60, 20, "hello")
    self.img1 = love.graphics.newImage('assets/payaso.jpg')
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
--

-- This is where we define our main game loop
main = State()

function main:load()
    self.player = require('player')
    -- Prepare physics world with horizontal and vertical gravity
    love.physics.setMeter(32) --sets the meter size in pixels
	self.physics = love.physics.newWorld(0, 0)
    self.level = require('levels').Level1
    print(self.level.owner)
    self.level:load(self, self.physics)
end

function main:update(dt)
    self.level:update(dt)
end

function main:render()
    -- Draw the map and all objects within
	self.level:render()

end















mainLoop = State()
return {mainMenu, main}