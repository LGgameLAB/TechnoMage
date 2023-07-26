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

for _, s in pairs(require('sprites')) do
	print(_, s)
end 
Asteroid = require('sprites').Asteroid

-- Warning, you are going to have to make some sort of uniform format across levels to manage sprites 
-- because currently the bullets are trying to locate themselves in level.map.layers[LAYERNAME]:add(SPRITE)

Chunk = class()

function Chunk:init(owner, x, y)
	self.owner = owner
	self.asteroids = {}
	self.x, self.y = x, y
	self.rect = Rect(x, y, owner.chunkWidth, owner.chunkHeight)
	
	math.randomseed(os.time())
	for a=1,owner.asteroidsPerChunk do
		local a = Asteroid(self, owner.owner.physics, math.random()*self.rect.w + x, math.random()*self.rect.h + y)
		owner.spriteLayer:add(a)
		table.insert(self.asteroids, a)
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
	self.asteroidsPerChunk = 11
	self.filepath = filepath
end

function AsteroidLevel:load(owner)
	self.owner = owner
	self.map = sti(self.filepath, { "box2d" })
	self.map:addSpriteLayer("Sprite Layer", 3) -- Name and stack index
	self.spriteLayer = self.map.layers["Sprite Layer"]
	self.spriteLayer:add(owner.player)
	self:loadChunk(0, 0)
	self.owner.player:setPos(500, 500)

	

	game.shaders.passes[3].on = false

	-- self.constructors = self.map.layers["constructors"]
	-- for k, v in ipairs(self.constructors.objects) do
	-- 	if v.name == "Player" then
	-- 		owner.player:setPos(v.x, v.y)
	-- 	else
	-- 		self.spriteLayer:add(sprites[v.name])
	-- 	end
	-- end

end

function AsteroidLevel:update(dt)
	self.map:update(dt)

	local p = self.owner.player
	local pVel = {p.body:getLinearVelocity()}
	local pPos = p.pos

	if pPos.x - self.chunk.x < pVel[1] * -2 then
		self:loadChunk(self.chunk.x - self.chunkWidth, self.chunk.y)
	elseif pPos.x - self.chunk.x > self.chunkWidth - pVel[1] * 2 then
		self:loadChunk(self.chunk.x + self.chunkWidth, self.chunk.y)
	end

	if pPos.y - self.chunk.y < pVel[2] * -2 then
		self:loadChunk(self.chunk.x, self.chunk.y - self.chunkHeight)
	elseif pPos.y - self.chunk.y > self.chunkHeight - pVel[2] * 2 then
		self:loadChunk(self.chunk.x, self.chunk.y + self.chunkHeight)
	end

	self:getCurrentChunk()


end

function AsteroidLevel:loadChunk(x, y)
	for _, c in pairs(self.chunks) do
		if c.x == x and c.y == y then
			return nil
		end
	end

	table.insert(self.chunks, Chunk(self, x, y))
	self:getCurrentChunk()
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
			self.map:drawLayer(layer)
			self.owner.cam:reverseDepth(d)
		end
	end

	if DEBUG then
		for _, c in pairs(self.chunks) do
			love.graphics.rectangle('line', c.x, c.y, self.chunkWidth, self.chunkHeight)
		end
	end
end

return {Level1 = TiledLevel('me', 'assets/maps/level1.lua'), Level0 = AsteroidLevel('assets/maps/level0.lua')}