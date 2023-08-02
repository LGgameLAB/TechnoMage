local function sign(number)
    if number > 0 then
        return 1
    elseif number < 0 then
        return -1
    else
        return 0
    end
end

Vector = require('libs/util/vector')
class = require('class')

Hudcontrol = class()
Hudcontrol:set({
    components = {},
    active=false
})

function Hudcontrol:init(...)
    self:add(...)
    self.active = true
end

function Hudcontrol:update(dt)
    for _, c in pairs(self.components) do
        c:update(dt)
    end
end

function Hudcontrol:draw()
    for _, c in pairs(self.components) do
        c:draw()
    end
end

function Hudcontrol:add(...)
    for _, e in pairs({...}) do
        table.insert(self.components, e)
    end
end

function Hudcontrol:remove(...)
    for _, e in pairs({...}) do
        for i, c in pairs(self.components) do
            if e == c then
                table.remove(self.components, i)
            end
        end
    end
end

GuideArrow = class()
GuideArrow:set({
    image = love.graphics.newImage('assets/objects/arrow.png')
})

function GuideArrow:init(player, dest)
    self.player = player
    self.dest = dest
    self.ang = 0
    self.scale = 1 
    self.srcSize = Vec(self.image:getWidth(), self.image:getHeight())
    local g = anim8.newGrid(180, 120, self.srcSize.x, self.srcSize.y)
    self.animations =  anim8.newAnimation(g('1-5',1), 0.1)
end

function GuideArrow:update(dt)
    local pc = self.player:getCenter()
    self.ang = pc:angleTo(self.dest.pos) + 3.141593 
    local s, c = math.sin(self.ang), math.cos(self.ang)
    -- print(self.player:getCenter())

    self.pos = Vector( sign(c) * math.sqrt(math.abs(c))*400*self.scale, sign(s) * math.sqrt(math.abs(s))*200*self.scale ) 
     + Vector(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)
    self.animations:update(dt)

    local pDist = pc:dist(self.dest.pos)

    if pDist < 200 then
        self.scale = 0
    elseif pDist < 400 then
        self.scale = (pDist-200)/200
    end
end

function GuideArrow:draw()
    self.animations:draw(self.image, self.pos.x, self.pos.y, self.ang, self.scale)
    -- love.graphics.circle('fill', self.dest.pos.x, self.dest.pos.y, 20)
end

return {GuideArrow=GuideArrow, Hudcontrol=Hudcontrol}