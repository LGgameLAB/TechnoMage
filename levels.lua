-- imports
require('settings')

sti = require 'libs/sti'

class = require('class')
Level = class()
Level:set({color = {1,1,1}})

function Level:init(owner, filepath)
    self.owner = owner
    self.filepath = filepath
end

-- Require Physics world to be passed
function Level:load(owner, world)
    self.map = sti(self.filepath, { "box2d" })
    self.map:box2d_init(world)

	function self.map:drawObjectLayer()
	end
	-- Creates a custom layer with an index within the layer stack
	self.map:addCustomLayer("Sprite Layer", 3)

	-- Add data to Custom Layer
	self.spriteLayer = self.map.layers["Sprite Layer"]
	self.spriteLayer.sprites = {
		owner.player
	}

	-- Update callback for Custom Layer
	function self.spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			sprite:update(dt)
		end
	end

	-- Draw callback for Custom Layer
	function self.spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			sprite:draw() --tx, ty, r, sx, sy, ox, oy, kx, ky 
		end
	end
end

function Level:update(dt)
    self.map:update(dt)
end

function Level:draw()
	for _, layer in ipairs(self.map.layers) do
		if layer.visible and layer.opacity > 0 and layer.type ~= 'objectlayer' then
			self.map:drawLayer(layer)
		end
	end
	-- love.event.push("quit")
    -- self.map:draw(0, 0)
	-- Draw Collision Map (useful for DEBUGging)
	if DEBUG then
		self.map:box2d_draw(0, 0)
	end
end

return {Level1 = Level('me', 'assets/maps/test2.lua')}