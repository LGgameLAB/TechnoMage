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
mainMenu = State:extend()

function mainMenu:load(owner)
    self.bigBtn = Button(self.owner, 20, 80, 60, 20, "hello", function () owner:switchStates(owner.states.main) end)
    game.shaders.passes[3].on = false
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
    self.cam.smoother = camera.smooth.damped(20)--camera.smooth.linear(100)
    self.dialogue = require('libs/dialove').init({
        font = love.graphics.newFont('libs/dialove/fonts/proggy-tiny/ProggyTiny.ttf', 32),
    })
    self.dCanv = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight() )
    self.hudlayer = require('hud').Hudcontrol()

    -- Prepare physics world with horizontal and vertical gravity
    love.physics.setMeter(32) --sets the meter size in pixels
	self.physics = love.physics.newWorld(0, 0, true)
    self.player:load(self, self.physics)
    self.level = require('levels').Level0
    self.level:load(self, self.physics)
    
    
    

    -- self.numLights = 1
    -- game.shaders.setParameter('numlights', self.numLights)
end

function main.addLight(t, i)
    
    for key, value in pairs(t) do
        game.shaders:setParameter('light', string.format("lights[%i].%s", i, key),  value)
    end
end

function main:drawLights()
    local lights = 1
    local buls = {}
    for k, v in ipairs(self.level.map.layers["Sprite Layer"].sprites) do
        if v._identify == "bullet" then
            -- print(#self.level.map.layers["Sprite Layer"].sprites)
            table.insert(buls, v)
            lights = lights + 1
        end
    end

    game.shaders:setParameter("light", "num_lights", lights)
    -- game.shaders:setParameter("light", "screen",  {love.graphics.getWidth(), love.graphics.getHeight()})
    self.addLight({
            position = { self.cam:cameraCoords(self.player.body:getX(), self.player.body:getY()) },
            diffuse = {1.0, 1.0, 1.0},
            power = 64,
        }, 0)
    
    for i, v in ipairs(buls) do
        -- print(i)
        self.addLight({
            position = { self.cam:cameraCoords(v.body:getX(), v.body:getY()) },
            diffuse = {1.0, 0.2, 0.2},
            power = 128,
        }, i)
    end
    

end

function main:update(dt)
    self:runEvents()

    self.physics:update(dt)
    self.dialogue:update(dt)
    self.level:update(dt)
    self.hudlayer:update(dt)
    -- self.cam:lookAt(self.player:getCenter():unpack())
    self.cam:lockPosition(self.player:getCenter():unpack())
    if love.window.getFullscreen() then
        self.cam.scale = 2
    else
        self.cam.scale = 1.5
    end
    -- self.cam.scale = 0.2
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
    self:drawLights()
    self.cam:detach()
    self.hudlayer:draw()
    local c = love.graphics.getCanvas()
    love.graphics.setCanvas( {self.dCanv, stencil=true})
    love.graphics.clear()
    self.dialogue:draw()
    love.graphics.setCanvas(c)
    love.graphics.draw(self.dCanv)

end









mainLoop = State()
return {mainMenu=mainMenu, main=main}