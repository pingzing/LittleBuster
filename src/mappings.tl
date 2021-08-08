local args = {...} as {string, SharedTable};
local LB = args[2];

-- This list controls which stats the addon will scan each tooltip line for.
-- The order of these matters! Stats will be scanned in order from top to bottom.
-- If we're looking at an item with "spell hit rating", but search for "hit rating" first, we'll
-- return hit rating values!
LB.StatDetails = {
    [1] = { kind = "ITEM_MOD_CRIT_SPELL_RATING", type ="Rating" },
    [2] = { kind = "ITEM_MOD_HIT_SPELL_RATING", type = "Rating" },
    [3] = { kind = "ITEM_MOD_HASTE_SPELL_RATING", type = "Rating" },
    [4] = { kind = "ITEM_MOD_CRIT_RANGED_RATING", type = "Rating" },
    [5] = { kind = "ITEM_MOD_HIT_RANGED_RATING", type = "Rating" },
    [6] = { kind = "ITEM_MOD_CRIT_MELEE_RATING", type = "Rating" },
    [7] = { kind = "ITEM_MOD_HIT_MELEE_RATING", type = "Rating" },
    [8] = { kind = "ITEM_MOD_EXPERTISE_RATING", type = "Rating" },
    [9] = { kind = "ITEM_MOD_HIT_RATING", type = "Rating" },
    [10] = { kind = "ITEM_MOD_CRIT_RATING", type = "Rating" },
    [11] = { kind = "ITEM_MOD_HASTE_RATING", type = "Rating" },
    [12] = { kind = "ITEM_MOD_DEFENSE_SKILL_RATING", type = "Rating" },
    [13] = { kind = "ITEM_MOD_BLOCK_RATING", type = "Rating" },
    [14] = { kind = "ITEM_MOD_DODGE_RATING", type = "Rating" },
    [15] = { kind = "ITEM_MOD_PARRY_RATING", type = "Rating" },
    [16] = { kind = "ITEM_MOD_AGILITY", type = "Attribute" },
    [17] = { kind = "ITEM_MOD_INTELLECT", type = "Attribute" },
    [18] = { kind = "ITEM_MOD_SPIRIT", type = "Attribute" },
    [19] = { kind = "ITEM_MOD_STAMINA", type = "Attribute" },
};

LB.ShortStatKeys = {
    ["ITEM_MOD_HIT_RATING"] = "ITEM_MOD_HIT_RATING_SHORT",
    ["ITEM_MOD_HIT_MELEE_RATING"] = "ITEM_MOD_HIT_MELEE_RATING_SHORT",
    ["ITEM_MOD_HIT_RANGED_RATING"] = "ITEM_MOD_HIT_RANGED_RATING_SHORT",
    ["ITEM_MOD_CRIT_RATING"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["ITEM_MOD_CRIT_MELEE_RATING"] = "ITEM_MOD_CRIT_MELEE_RATING_SHORT",
    ["ITEM_MOD_CRIT_RANGED_RATING"] = "ITEM_MOD_CRIT_RANGED_RATING_SHORT",
    ["ITEM_MOD_HASTE_RATING"] = "ITEM_MOD_HASTE_RATING_SHORT",
    ["ITEM_MOD_EXPERTISE_RATING"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["ITEM_MOD_HIT_SPELL_RATING"] = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["ITEM_MOD_CRIT_SPELL_RATING"] = "ITEM_MOD_CRIT_SPELL_RATING_SHORT",
    --    ["ITEM_MOD_HASTE_SPELL_RATING"] = "ITEM_MOD_HASTE_SPELL_RATING_SHORT", -- This doesn't seem to exist, actually
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["ITEM_MOD_BLOCK_RATING"] = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["ITEM_MOD_DODGE_RATING"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["ITEM_MOD_PARRY_RATING"] = "ITEM_MOD_PARRY_RATING_SHORT",
    ["ITEM_MOD_AGILITY"] = "ITEM_MOD_AGILITY_SHORT",
    ["ITEM_MOD_INTELLECT"] = "ITEM_MOD_INTELLECT_SHORT",
    ["ITEM_MOD_SPIRIT"] = "ITEM_MOD_SPIRIT_SHORT",
    ["ITEM_MOD_STAMINA"] = "ITEM_MOD_STAMINA_SHORT",
};

-- Used for ratings only, to look up the key to pass to GetEffectFromRating().
LB.StatKeyToRatingID = {
    ["ITEM_MOD_HIT_RATING"] = CR_HIT_MELEE,
    ["ITEM_MOD_HIT_MELEE_RATING"] = CR_HIT_MELEE,
    ["ITEM_MOD_HIT_RANGED_RATING"] = CR_HIT_RANGED,
    ["ITEM_MOD_CRIT_RATING"] = CR_CRIT_MELEE,
    ["ITEM_MOD_CRIT_MELEE_RATING"] = CR_CRIT_MELEE,
    ["ITEM_MOD_CRIT_RANGED_RATING"] = CR_CRIT_RANGED,
    ["ITEM_MOD_HASTE_RATING"] = CR_HASTE_MELEE,
    ["ITEM_MOD_EXPERTISE_RATING"] = CR_EXPERTISE,
    ["ITEM_MOD_HIT_SPELL_RATING"] = CR_HIT_SPELL,
    ["ITEM_MOD_CRIT_SPELL_RATING"] = CR_CRIT_SPELL,
    ["ITEM_MOD_HASTE_SPELL_RATING"] = CR_HASTE_SPELL,
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = CR_DEFENSE_SKILL,
    ["ITEM_MOD_BLOCK_RATING"] = CR_BLOCK,
    ["ITEM_MOD_DODGE_RATING"] = CR_DODGE,
    ["ITEM_MOD_PARRY_RATING"] = CR_PARRY,
};

LB.RatingIDToStatKey = {
    [CR_HIT_MELEE] = "ITEM_MOD_HIT_RATING",
    --[CR_HIT_MELEE] = "ITEM_MOD_HIT_MELEE_RATING", -- prefer the more general stat rating key
    [CR_HIT_RANGED] = "ITEM_MOD_HIT_RANGED_RATING",
    [CR_CRIT_MELEE] = "ITEM_MOD_CRIT_RATING",
    --[CR_CRIT_MELEE] = "ITEM_MOD_CRIT_MELEE_RATING", -- prefer the more general stat rating key
    [CR_CRIT_RANGED] = "ITEM_MOD_CRIT_RANGED_RATING",
    [CR_HASTE_MELEE] = "ITEM_MOD_HASTE_RATING",
    [CR_EXPERTISE] = "ITEM_MOD_EXPERTISE_RATING",
    [CR_HIT_SPELL] = "ITEM_MOD_HIT_SPELL_RATING",
    [CR_CRIT_SPELL] = "ITEM_MOD_CRIT_SPELL_RATING",
    [CR_HASTE_SPELL] = "ITEM_MOD_HASTE_SPELL_RATING",
    [CR_DEFENSE_SKILL] = "ITEM_MOD_DEFENSE_SKILL_RATING",
    [CR_BLOCK] = "ITEM_MOD_BLOCK_RATING",
    [CR_DODGE] = "ITEM_MOD_DODGE_RATING",
    [CR_PARRY] = "ITEM_MOD_PARRY_RATING",
};

LB.StatKeyIsPercentage = {
    ["ITEM_MOD_HIT_RATING"] = true,
    ["ITEM_MOD_HIT_MELEE_RATING"] = true,
    ["ITEM_MOD_HIT_RANGED_RATING"] = true,
    ["ITEM_MOD_CRIT_RATING"] = true,
    ["ITEM_MOD_CRIT_MELEE_RATING"] = true,
    ["ITEM_MOD_CRIT_RANGED_RATING"] = true,
    ["ITEM_MOD_HASTE_RATING"] = true,
    ["ITEM_MOD_EXPERTISE_RATING"] = false,
    ["ITEM_MOD_HIT_SPELL_RATING"] = true,
    ["ITEM_MOD_CRIT_SPELL_RATING"] = true,
    ["ITEM_MOD_HASTE_SPELL_RATING"] = true,
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = false,
    ["ITEM_MOD_BLOCK_RATING"] = true,
    ["ITEM_MOD_DODGE_RATING"] = true,
    ["ITEM_MOD_PARRY_RATING"] = true,
};

LB.ClassNameToId = {
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["SHAMAN"] = 6,
    ["WARLOCK"] = 8,
    ["MAGE"] = 7,
    ["DRUID"] = 9
};
