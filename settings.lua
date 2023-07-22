function dump(tbl)
    for k, v in ipairs(tbl) do
        print(k, v)
    end
end
CROSSHATCH = false
DEBUG = false

binds = {
    rocket = 'w',
    reverseRocket = 's',
    rotR = 'd',
    rotL = 'a',
    shoot = 'space'
}