class = require('class')

Sprite = class()

function Sprite:init()
end

function Sprite.load(self, layers)
    self.layers = {}
    for k, v in ipairs(layers or {}) do
        if type(v) == 'string' then
            l = game.state.level.map.layers[v]
            table.insert(self.layers, l)
            l:add(self)
        else
            v:add(self)
        end
    end

end

function Sprite.draw(self)
end

function Sprite.update(self, dt)
end

function Sprite.kill(self)
    for _, l in ipairs(self.layers or {}) do
        l:remove(self)
    end
    -- if self.body then
    --     self.body:release()
    -- end
end

return Sprite