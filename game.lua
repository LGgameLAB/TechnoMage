-- This is essentially a state manager for the entire game
-- The game object is also responsible for higher level function
-- such as save state management
require('settings')
class = require('class')
Game = class()

function Game:init()
end

function Game:load()
    -- self.shaders = require('libs/shaders')
    -- self.shaders:init()
    self.timer = require('libs/util/timer')

    -- if self.shaders then
    --     self.shaders:refresh()
    -- end

    self.states = require('states')
    self.state = nil
    self:switchStates(self.states.main)--Menu)

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
    -- self.shaders:predraw()
    self.state:draw()
    -- self.shaders:postdraw()
end

function Game:update(dt)
    self.timer.update(dt)
    self.state:update(dt)
end

return Game