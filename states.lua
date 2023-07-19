class = require('class')
State = class()

function State:init(tbl)
    self.owner = owner
    self.active = false
    self.paused = true

    self.canToggleFull = true

end

function State:load()
end

function State:activate(owner)
    if not self.active then
        self:load(owner)
    end
    self.active = true
    self.paused = false
    
end

function State:deactivate(stayLoaded)
    self.active = stayLoaded
    self.paused = true
    if not active then
        self:unload()
    end
end

function State:unload()
    -- Collect garbage here to free up space
end

function State:update(dt)
    self.runEvents()
end

function State:runEvents()
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end

    if love.keyboard.isDown("f11") and self.canToggleFull then
        love.window.setFullscreen(not love.window.getFullscreen())
        self.canToggleFull = false
        game.timer.after(0.5, function()self.canToggleFull = true end)
    end
end

function State:draw()

end

 
Button = require('ui').Button
-- This is where we define our Menu Scene
mainMenu = State()

function mainMenu:load(owner)
    self.bigBtn = Button(self.owner, 20, 80, 60, 20, "hello", function () owner:switchStates(owner.states.main) end)
end

function mainMenu:update(dt)
    self:runEvents()
    self.bigBtn:update(dt)
end
function mainMenu:draw()
    State:draw()
    self.bigBtn:draw()
    w, h, v = love.window.getMode()
    love.graphics.setColor(1,1,1)
    love.graphics.print(string.format("Width: %.1f | Height: %.1f", w, h), 22,22)
end
--

-- This is where we define our main game loop
main = State()

function main:load(owner)
    self.owner = owner

    self.player = require('player')
    
    local camera = require('libs/util/camera')
    self.cam = camera(0,0, 1)
    self.cam.smoother = camera.smooth.damped(2)--camera.smooth.linear(100)
    
    -- Prepare physics world with horizontal and vertical gravity
    love.physics.setMeter(32) --sets the meter size in pixels
	self.physics = love.physics.newWorld(0, 0)
    self.level = require('levels').Level1
    self.level:load(self, self.physics)
    self.player:load(self, self.physics)

    
end

function main:update(dt)
    self:runEvents()
    self.physics:update(dt)
    self.level:update(dt)
    -- self.cam:lookAt(self.player:getCenter():unpack())
    self.cam:lockPosition(self.player:getCenter():unpack())
    if love.window.getFullscreen() then
        self.cam.scale = 2
    else
        self.cam.scale = 1.5
    end
     
end

function main:draw()
    -- Draw the map and all objects within
    self.cam:attach()
	self.level:draw()
    self.player:draw()
    self.cam:detach()

end









mainLoop = State()
return {mainMenu=mainMenu, main=main}