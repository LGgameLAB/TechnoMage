Util = require('util')
class = require('class')

Button = class()
Button:set({
    colors = {
        default = {0.1, 0.1, 0.5},
        hover={0.9, 0.9, 0.9}
    },
    hovered = false
})

function Button:init(owner, x, y, w, h, text, callback)
    self.owner = owner
    self.rect = Util.Rect(x, y, w, h)

    if text then
        self.text = love.graphics.newText(love.graphics.getFont( ), text)
    else
        self.text = text
    end

    self.callback = callback or function() return nil end
    -- print(love.mouse.getRelativeMode( ))
end

function Button:update(dt)
    local x, y = love.mouse.getPosition()
    local mouserect = Util.Rect(x, y, 1, 1)
    self.hovered = mouserect:collide(self.rect)
    if self.hovered and love.mouse.isDown(1) then
        -- print('not ')
        self.callback()
    end
end

function Button:draw()
    
    local color = nil
    if self.hovered then
        color = self.colors.hover
    else
        color = self.colors.default
    end
    love.graphics.setColor(unpack(color))

    love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.w, self.rect.h)
    if self.text then
        love.graphics.draw(self.text, self.rect.x, self.rect.y)
    end
end

return {Button=Button}