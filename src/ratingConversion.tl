local args = {...} as {string, SharedTable};
local LB = args[2];

-- Level 60 rating base
local _ratingBase: {number:number} = {
    [CR_DEFENSE_SKILL] = 1.5,
    [CR_DODGE] = 12.0,
    [CR_PARRY] = 15.0,
    [CR_BLOCK] = 5.0,
    [CR_HIT_MELEE] = 10,
    [CR_HIT_RANGED] = 10,
    [CR_HIT_SPELL] = 8,
    [CR_CRIT_MELEE] = 14,
    [CR_CRIT_RANGED] = 14,
    [CR_CRIT_SPELL] = 14,
    [CR_HASTE_MELEE] = 10, -- changed in 2.2
    [CR_HASTE_RANGED] = 10, -- changed in 2.2
    [CR_HASTE_SPELL] = 10, -- changed in 2.2 
    [CR_EXPERTISE] = 2.5,
}

local _level34Ratings: {number:boolean} = {
    [CR_DEFENSE_SKILL] = true,
    [CR_DODGE] = true,
    [CR_PARRY] = true,
    [CR_BLOCK] = true,
}

-- Takes a rating value and ID, and returns the actual numeric value that stat rating provides
-- to the player at their current level.
--
-- `rating` The rating amount to convert to stat value.
--
--`id` The numeric ID of the stat to convert.
--
-- Returns: A number of the given rating converted to the value is provides.
LB.GetEffectFromRating = function(rating: number, id: number): number 
    local level = UnitLevel("player");
    -- 2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players
    --   will now convert these ratings into their corresponding defensive
    --   stats at the same rate as level 34 players.    
    if level < 34 and _level34Ratings[id] then
        level = 34;
    end
    if level >= 60 then
        return rating / _ratingBase[id] / (82 / (262 - 3 * level));
    elseif level >= 10 then
        return rating / _ratingBase[id] / ((level - 8) / 52);
    else
        return rating / _ratingBase[id] / (2 / 52);
    end
end
