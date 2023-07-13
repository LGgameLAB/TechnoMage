-- imports
sti = require 'libs/sti'

Level = setmetatable({}, require('class'))
Level.__index = Level

function Level.new(owner, filepath)
    self = setmetatable({}, Level)
    self.owner = owner
    self.filepath = filepath
    return self
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
	local spriteLayer = self.map.layers["Sprite Layer"]
	spriteLayer.sprites = {
		owner.player
	}

	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			sprite:update(dt)
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		-- for _, sprite in pairs(self.sprites) do
		-- 	sprite:draw() --tx, ty, r, sx, sy, ox, oy, kx, ky 
		-- end
	end
end

function Level:update(dt)
    self.map:update(dt)
end

function Level:render()
	-- for _, layer in pairs(self.map.layers) do
	-- 	-- if getmetatable(layer) ~= sti.ObjectLayer then
	-- 	self.map:drawLayer(layer)
	-- end
    self.map:draw(0, 0)
	-- Draw Collision Map (useful for debugging)
	self.map:box2d_draw(0, 0)
end

return {Level1 = Level('me', 'assets/maps/test2.lua')}