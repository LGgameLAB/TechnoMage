-- This is essentially a state manager for the entire game
-- The game object is also responsible for higher level function
-- such as save state management
require('settings')

class = require('class')
Game = class()

function Game:init()
end

function Game:load()
    self.shaders = require('libs/shaders')
    self.shaders:init(nil, 3)
    scale = 1
    self.shaders:set(1, 'chromatic_aberration')
    self.shaders:set(2, 'radialblur')
    self.shaders:set(3, 'light')
    self.timer = require('libs/util/timer')

    if self.shaders then
        self.shaders:refresh()
    end
    self.abc = {
        red = {0, 0},
        green = {0, 0},
        blue = {0, 0}
    }
    self.abf = {
        red = {4.0, 3.0},
        green = {-2.0, -1.0},
        blue = {1.0, -3.0}
    }
    self.blur = {0}

    self.redStrength = {0, 0}
    self.timer.tween(1.5, self.abc, self.abf, 'elastic', function()
        self.timer.tween(0.5, self.abc, {
            red = {0, 0},
            green = {0, 0},
            blue = {0, 0}
        }, 'elastic' )
    end)
    self.timer.tween(1, self.blur, {-0.05}, 'elastic', function()
        self.timer.tween(1, self.blur, {0}, 'elastic')
    end)

    self.states = require('states')
    self.state = nil
    self:switchStates(self.states.main)

    self:loadSave()
end

function Game:loadSave()
end

function Game:switchStates(newState, stayLoaded)
    if state then
        self.state:deactivate(stayLoaded)
        self.state = newState
    else
        self.state = newState
    end
    
    self.state:activate(self)
end

function Game:draw()
    self.shaders:predraw()
    self.state:draw()
    self.shaders:postdraw()
end

function Game:getCanvas()
    return self.shaders.curcanvas.canvas
end

function Game:update(dt)
    self.shaders:setParameter('chromatic_aberration', 'redStrength', self.abc.red)
    self.shaders:setParameter('chromatic_aberration', 'greenStrength', self.abc.green)
    self.shaders:setParameter('chromatic_aberration', 'blueStrength', self.abc.blue)
    self.shaders:setParameter('radialblur', 'blurwidth', self.blur[1])

    self.timer.update(dt)
    self.state:update(dt)
end

return Game