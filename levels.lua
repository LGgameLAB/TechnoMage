-- imports
sti = require 'libs/sti/sti'

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
			sprite.r = sprite.r + math.rad(90 * dt)
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local x, y = unpack(sprite.pos)
			local r = sprite.r
			love.graphics.draw(sprite.image, x, y, r)
		end
	end
end

function Level:update(dt)
    -- self.map:update(dt)
end

function Level:render()
    love.graphics.setColor(1, 1, 1)
    self.map:draw(0, 0, 2, 2)
	-- -- Draw Collision Map (useful for debugging)
	-- love.graphics.setColor(1, 0, 0)
	-- self.map:box2d_draw()
end

return {Level1 = Level('me', 'assets/maps/test2.lua')}