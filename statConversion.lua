local addonName, LB = ...;

-- Level 60 rating base
local _ratingBase = {
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

local _level34Ratings = {
    [CR_DEFENSE_SKILL] = true,
    [CR_DODGE] = true,
    [CR_PARRY] = true,
    [CR_BLOCK] = true,
}

local _ratingNameToID = {
    [CR_DEFENSE_SKILL] = "DEFENSE_RATING",
    [CR_DODGE] = "DODGE_RATING",
    [CR_PARRY] = "PARRY_RATING",
    [CR_BLOCK] = "BLOCK_RATING",
    [CR_HIT_MELEE] = "MELEE_HIT_RATING",
    [CR_HIT_RANGED] = "RANGED_HIT_RATING",
    [CR_HIT_SPELL] = "SPELL_HIT_RATING",
    [CR_CRIT_MELEE] = "MELEE_CRIT_RATING",
    [CR_CRIT_RANGED] = "RANGED_CRIT_RATING",
    [CR_CRIT_SPELL] = "SPELL_CRIT_RATING",
    [CR_HASTE_MELEE] = "MELEE_HASTE_RATING",
    [CR_HASTE_RANGED] = "RANGED_HASTE_RATING",
    [CR_HASTE_SPELL] = "SPELL_HASTE_RATING",
    [CR_EXPERTISE] = "EXPERTISE_RATING",
    ["DEFENSE_RATING"] = CR_DEFENSE_SKILL,
    ["DODGE_RATING"] = CR_DODGE,
    ["PARRY_RATING"] = CR_PARRY,
    ["BLOCK_RATING"] = CR_BLOCK,
    ["MELEE_HIT_RATING"] = CR_HIT_MELEE,
    ["RANGED_HIT_RATING"] = CR_HIT_RANGED,
    ["SPELL_HIT_RATING"] = CR_HIT_SPELL,
    ["MELEE_CRIT_RATING"] = CR_CRIT_MELEE,
    ["RANGED_CRIT_RATING"] = CR_CRIT_RANGED,
    ["SPELL_CRIT_RATING"] = CR_CRIT_SPELL,
    ["MELEE_HASTE_RATING"] = CR_HASTE_MELEE,
    ["RANGED_HASTE_RATING"] = CR_HASTE_RANGED,
    ["SPELL_HASTE_RATING"] = CR_HASTE_SPELL,
    ["EXPERTISE_RATING"] = CR_EXPERTISE,
}

-- Takes a rating value and ID, and returns the actual numeric value that stat rating provides
-- to the player at their current level.
--
-- `rating` The rating amount to convert to stat value.
--
--`id` The ID of the stat to convert, either in numeric ID form, or SCREAMING_SNAKE form.
--
-- Returns: A number of the given rating converted to the value is provides.
function LB.GetEffectFromRating(rating, id)
    -- if id is stringID then convert to numberID
    if type(id) == "string" and _ratingNameToID[id] then
        id = _ratingNameToID[id];
    end
    -- check for invalid input
    if type(rating) ~= "number" or id < 1 or id > 26 then
        return 0;
    end
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
