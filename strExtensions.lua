local addonName, LB = ...;

function LB.strStartsWith(str, start)
    return str:sub(1, #start) == start
end

function LB.strStripColors(str)
    if (LB.strStartsWith(str, "|c")) then
        return str:sub(11);
    end
    return str;
end
