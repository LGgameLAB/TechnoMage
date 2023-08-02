class = require('class')

Sprite = class()

function Sprite:init()
end

function Sprite.load(self, layers)
    self:addLayers(layers)

end

function Sprite:addLayers(layers)
    self.layers = {}
    for k, v in ipairs(layers or {}) do
        if type(v) == 'string' then
            l = game.state.level.map.layers[v]
            table.insert(self.layers, l)
            l:add(self)
        else
            if v.add then
                v:add(self)
            else
                table.insert(v, self)
            end
            table.insert(self.layers, v)
        end
    end
end

function Sprite.draw(self)
end

function Sprite.update(self, dt)
end

function Sprite.kill(self)
    -- print('goober')
    
    for _, l in ipairs(self.layers or {}) do
        if l.remove then
            l:remove(self)
        else
            for i, s in pairs(l) do
                if s == self then
                    table.remove(l, i)
                end
            end
        end
    end

    if self.body then
        self.body:setActive(false)
    end
end

return Sprite