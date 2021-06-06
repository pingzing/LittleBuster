local args = { ... };
local LB = args[2];

LB.strStartsWith = function(str, start)
   return str:sub(1, #start) == start
end
