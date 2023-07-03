return {__call = function (cls, ...) return cls.new(...) end}

-- The Class format basically organizes the lua table such that it acts like a python Class
-- This for mere convenience