-- This is essentially a state manager for the entire game
-- The game object is also responsible for higher level function
-- such as save state management

Game = setmetatable({}, require('class'))
Game.__index = Game

function Game.new()
    self = setmetatable({}, Game)
    return self
end

function Game:load()
    self.shaders = require('libs/shaders')
    self.shaders:init()
    if self.shaders then
        self.shaders:refresh()
    end

    self.states = require('states')
    self.state = nil
    self:switchStates(self.states.mainMenu)

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

function Game:update(dt)
    self.state:update(dt)
end

return Game