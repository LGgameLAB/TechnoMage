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
	self.owner = owner
	
    self.map = sti(self.filepath, { "box2d" })
    self.map:box2d_init(world)
	for _, obj in pairs(self.map.box2d_collision) do
		if obj.fixture then
			obj.fixture:setCategory(2)
			obj.fixture:setGroupIndex( 300 )
		end
	end


	function self.map:drawObjectLayer()
	end

	self.map:addSpriteLayer("Sprite Layer", 3) -- Name and stack index

	self.spriteLayer = self.map.layers["Sprite Layer"]
	self.spriteLayer:add(owner.player)

	self.constructors = self.map.layers["constructors"]
	for k, v in ipairs(self.constructors.objects) do
		if v.name == "Player" then
			owner.player:setPos(v.x, v.y)
		end
	end


end

function Level:update(dt)
    self.map:update(dt)
end

function Level:draw()
	for _, layer in ipairs(self.map.layers) do
		if layer.visible and layer.opacity > 0 and layer.type ~= 'objectlayer' then
			d = layer.properties.depth
			if d then
				-- print(d)
				self.owner.cam:setDepth(d)
			end
			self.map:drawLayer(layer)
			if d then 
				self.owner.cam:reverseDepth(d)
			end
		end
	end
	-- love.event.push("quit")
    -- self.map:draw(0, 0)
	-- Draw Collision Map (useful for DEBUGging)
	if DEBUG then
		self.map:box2d_draw(0, 0)
	end
end

return {Level1 = Level('me', 'assets/maps/level1.lua')}