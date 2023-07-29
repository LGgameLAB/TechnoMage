-- imports
require('settings')

Vector = require('libs/util/vector')

sti = require 'libs/sti'
sprites = require 'sprites'

class = require('class')
TiledLevel = class()
TiledLevel:set({color = {1,1,1}})

function TiledLevel:init(owner, filepath)
    self.owner = owner
    self.filepath = filepath
end

-- Require Physics world to be passed
function TiledLevel:load(owner, world)
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

	game.shaders.passes[3].on = false

	self.constructors = self.map.layers["constructors"]
	for k, v in ipairs(self.constructors.objects) do
		if v.name == "Player" then
			owner.player:setPos(v.x, v.y)
		else
			self.spriteLayer:add(sprites[v.name])
		end
	end

end

function TiledLevel:update(dt)
    self.map:update(dt)
end

function TiledLevel:draw()
	for _, layer in ipairs(self.map.layers) do
		if layer.visible and layer.opacity > 0 and layer.type ~= 'objectlayer' then
			d = layer.properties.depth
			if d then
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

--
Rect = require('util').Rect

-- for _, s in pairs(require('sprites')) do
-- 	print(_, s)
-- end 
Asteroid = require('sprites').Asteroid

-- Warning, you are going to have to make some sort of uniform format across levels to manage sprites 
-- because currently the bullets are trying to locate themselves in level.map.layers[LAYERNAME]:add(SPRITE)

Chunk = class()

function Chunk:init(owner, x, y)
	self.owner = owner
	self.asteroids = {}
	self.x, self.y = x, y
	self.rect = Rect(x, y, owner.chunkWidth, owner.chunkHeight)
	
	for a=1,owner.asteroidsPerChunk do
		local a = Asteroid(self, owner.owner.physics, math.random()*self.rect.w + x, math.random()*self.rect.h + y, {owner.spriteLayer, owner.map.box2d_collision})
		table.insert(self.asteroids, a)

	end
end

function Chunk:destroy()
	for _, s in pairs(self.asteroids) do
		s:kill()
	end
end
AsteroidLevel = class()

function AsteroidLevel:init(filepath)
	-- stores all chunks
	self.chunks = {}
	-- stores current chunk
	self.chunk = nil
	self.chunkWidth = 1000
	self.chunkHeight = 1000
	self.asteroidsPerChunk = 12
	self.loadDist = 1500
	self.unloadDist = 2500
	self.filepath = filepath
end

function AsteroidLevel:load(owner, world)
	self.owner = owner
	self.map = sti(self.filepath, { "box2d" })
	self.map:box2d_init(world)
	self.map:addSpriteLayer("Sprite Layer", 3) -- Name and stack index
	self.spriteLayer = self.map.layers["Sprite Layer"]
	self.spriteLayer:add(owner.player)
	math.randomseed(os.time())
	self:loadChunk(0, 0)
	self.owner.player:setPos(500, 500)
	table.insert(self.map.box2d_collision, owner.player)

	local goob = require('sprites').Goober(self, {1000, 800})

	self.spriteLayer:add(goob)
	-- table.insert(self.map.box2d_collision, goob)

	game.shaders.passes[3].on = false

	owner.dialogue:show({
		text="Welcome to Cycadia asteroid belt!",
		background = {
			color = {0,0,0,0.8},
		}
	})

end

function AsteroidLevel:update(dt)
	self.map:update(dt)

	-- Create New Chunks
	local p = Vector(self.owner.player.body:getX(), self.owner.player.body:getY())
	local cx, cy = unpack(self.chunk.rect:getval('center'))
	for x=-1, 1 do
		for y=-1, 1 do
			-- if not (x==0 and y==0) then
			local newPos = Vector(cx + x*self.chunkWidth, cy + y*self.chunkHeight)
			local d = p:dist(newPos)
			if d < self.loadDist then
				self:loadChunk(self.chunk.x + x*self.chunkWidth, self.chunk.y + y*self.chunkHeight)
			end
			-- end
		end
	end

	-- Delete Old ones
	for _, c in pairs(self.chunks) do
		if Vector(unpack(c.rect:getval('center'))):dist(self.owner.player:getCenter()) > self.unloadDist then
			self:deleteChunk(c)
		end
	end
	self:getCurrentChunk()
	-- print(#self.spriteLayer.sprites)

end

function AsteroidLevel:loadChunk(x, y)
	for _, c in pairs(self.chunks) do
		if c.x == x and c.y == y then
			return nil
		end
		-- print("already loaded dum dum")
	end

	table.insert(self.chunks, Chunk(self, x, y))
	self:getCurrentChunk()
end

function AsteroidLevel:deleteChunk(chunk)
	for _, c in pairs(self.chunks) do
		if c == chunk then
			c:destroy()
			table.remove(self.chunks, _)
			return 
		end
	end
end

function AsteroidLevel:getCurrentChunk()
	local p = self.owner.player
	local playerRect = Rect(0, 0, p.w, p.h)
	playerRect:setCenter(p:getCenter():unpack())
	for _, c in pairs(self.chunks) do
		if c.rect:collide(playerRect) then
			self.chunk = c
			return
		end
	end

	error('player is outside of all chunks')
end

-- Really should ignore tile layers but whatever
function AsteroidLevel:draw()
	for _, layer in ipairs(self.map.layers) do
		if layer.visible and layer.opacity > 0 and layer.type ~= 'objectlayer' then
			d = layer.properties.depth or nil
			self.owner.cam:setDepth(d)
			if layer.type == 'imagelayer' then
				self.map:drawImageLayer(layer, self.owner.player.body:getX(), self.owner.player.body:getY())
			else
				self.map:drawLayer(layer, 0, 0)
			end
			self.owner.cam:reverseDepth(d)
		end
	end

	if DEBUG then
		self.map:box2d_draw()
		for _, c in pairs(self.chunks) do
			if (c.x == self.chunk.x) and (c.y == self.chunk.y) then
				love.graphics.setColor(0.8, 0.1, 0.1)
				love.graphics.rectangle('line', c.x, c.y, self.chunkWidth, self.chunkHeight)
				love.graphics.setColor(1, 1, 1)
			else
				love.graphics.setColor(1, 1, 1, 0.2)
				love.graphics.rectangle('line', c.x, c.y, self.chunkWidth, self.chunkHeight)
				love.graphics.setColor(1, 1, 1, 1)
			end
		end
	end
end

return {Level1 = TiledLevel('me', 'assets/maps/level1.lua'), Level0 = AsteroidLevel('assets/maps/level0.lua')}