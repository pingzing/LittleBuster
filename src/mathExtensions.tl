local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local floor = math.floor;

-- This is reverse-engineered, and may not be completely correct.
-- Basically, it appears that for fractional attribute values (i.e. Agility, Intellect),
-- Blizzard rounds up only at .7 or greater. Anything less gets rounded down.
LB.BlizzRound = function (x: number): number
    return floor(x + 0.34);
end