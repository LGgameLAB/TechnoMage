Player = setmetatable({
    size = {5,5},
    name = "BOB"
}, require('class'))
Player.__index = Player


function Player.new(name, size)
    local self = setmetatable({}, Player)
    self.size = size
    self.name = name
    return self
end

function Player:getDisc()
    return string.format("My name is %s and I am thicc (%.f Feet x %.f Feet)", self.name, self.size[1], self.size[2])
end

p1 = Player("bob", {10, 10})
print( p1:getDisc() )
print( p1.name )
return Player