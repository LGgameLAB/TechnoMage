Util = require('util')

Button = setmetatable({
    colors = {
        default = {0.1, 0.1, 0.5},
        hover={0.9, 0.9, 0.9}
    },
    hovered = false
}, require('class'))
Button.__index = Button

function Button.new(owner, x, y, w, h, text)
    local self = setmetatable({}, Button)
    self.owner = owner
    self.rect = Util.Rect(x, y, w, h)
    if text then
        self.text = love.graphics.newText(love.graphics.getFont( ), text)
    else
        self.text = text
    end
    -- print(love.mouse.setRelativeMode( ))
    return self
end

function Button:update(dt)
    local x, y = love.mouse.getPosition()
    self.hovered = Util.Rect(x, y, 1, 1):collide(self.rect)
    print(self.hovered)
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

return {button=Button}