local all = {}

for n, s in pairs(require('sprites.enemies')) do
    all[n] = s
end

for n, s in pairs(require('sprites.asteroid')) do
    all[n] = s
end


return all