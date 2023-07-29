FX = require('class')()

HURTFX = [[
    //extern int time = 0;
    //extern int duration = 400;

    vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
        vec4 texcolor = Texel(texture, texture_coords);

        texcolor.r = 1.0;
        
        return texcolor;
    }
]]
function FX:init(w, h)
    self.w, self.h = w, h
    self.status = 'normal'
    self.queue = {}
end

function FX:draw(drawFunc)
    love.graphics.setShader(self.queue[1].shader)
    drawFunc()
    love.graphics.setShader()
end

function FX:add(obj)
    -- if obj.code == 'hurt' then
        
    -- end
    table.insert(self.queue, {
        duration = 3000, 
        startup = love.timer.getTime(),
        shader = love.graphics.newShader(HURTFX)
    })
end

function FX:update(dt)
    self.shader = self.queue[1].shader
    -- self.shader:send('time', love.timer.getTime() - self.queue[1].startup)
    -- self.shader:send('duration', self.queue[1].duration)  
end

return FX