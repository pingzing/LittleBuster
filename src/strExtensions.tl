local args = {...} as {string, SharedTable};
local LB = args[2];

LB.strStartsWith = function(str: string, start: string): boolean
    return str:sub(1, #start) == start
end

-- function LB.strStripColors(str)
--     if (LB.strStartsWith(str, "|c")) then
--         return str:sub(11);
--     end
--     return str;
-- end
