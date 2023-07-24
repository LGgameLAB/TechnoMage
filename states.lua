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
        self.owner.shaders:refresh()
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
	self.physics = love.physics.newWorld(0, 0, true)
    self.level = require('levels').Level1
    self.level:load(self, self.physics)
    self.player:load(self, self.physics)

    -- self.lightCanvas = love.graphics.newCanvas()
    -- self.lighter = require('libs/lighter')()
    -- for _, body in pairs(self.physics:getBodies()) do
    --     for _, fixture in pairs(body:getFixtures()) do
    --         shape = fixture:getShape()
    --         self.lighter:addPolygon({shape:getPoints()})
    --     end
    -- end
    -- self.light1 = self.lighter:addLight(10, 300, 500, 0.8,0.8,0.8)
    -- love.graphics.stencil = true
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
    
    game.shaders:setParameter("light", "screen", {love.graphics.getWidth(), love.graphics.getHeight()})
    game.shaders:setParameter("light", "num_lights", 1)    
    game.shaders:setParameter("light", "lights[0].position", {self.cam:cameraCoords(self.player.body:getX(), self.player.body:getY())} )--self.state.player:getCenter():toTable())--{love.graphics.getWidth() / 2.0, love.graphics.getHeight() / 2.0})
    game.shaders:setParameter("light", "lights[0].diffuse", {1.0, 1.0, 1.0})
    game.shaders:setParameter("light", "lights[0].power", 64)

end

-- function main:preDrawLights()
--     love.graphics.setCanvas({ self.lightCanvas, stencil = true})
--     love.graphics.clear(0.4, 0.4, 0.4) -- Global illumination level
--     self.lighter:drawLights()
--     love.graphics.setCanvas()
--     love.graphics.clear()
-- end

-- function main:drawLight()
--     love.graphics.setBlendMode("multiply", "premultiplied")
--     love.graphics.draw(self.lightCanvas)
--     love.graphics.setBlendMode("alpha")
-- end

function main:draw()
    -- Draw the map and all objects within

    self.cam:attach()
    self.level:draw()
    self.player:draw()
    self.cam:detach()



end









mainLoop = State()
return {mainMenu=mainMenu, main=main}