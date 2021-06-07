local args = {...} as {string, SharedTable};
local LB = args[2];

-- The order of these matters! Stats will be scanned in order from top to bottom.
-- If we're looking at an item with "spell hit rating", but search for "hit rating" first, we'll
-- return hit rating values!
LB.StatKeys = {
    [1] = { key = "ITEM_MOD_CRIT_SPELL_RATING", type ="Rating" },
    [2] = { key = "ITEM_MOD_HIT_SPELL_RATING", type = "Rating" },
    [3] = { key = "ITEM_MOD_HASTE_SPELL_RATING", type = "Rating" },
    [4] = { key = "ITEM_MOD_CRIT_RANGED_RATING", type = "Rating" },
    [5] = { key = "ITEM_MOD_HIT_RANGED_RATING", type = "Rating" },
    [6] = { key = "ITEM_MOD_CRIT_MELEE_RATING", type = "Rating" },
    [7] = { key = "ITEM_MOD_HIT_MELEE_RATING", type = "Rating" },
    [8] = { key = "ITEM_MOD_EXPERTISE_RATING", type = "Rating" },
    [9] = { key = "ITEM_MOD_HIT_RATING", type = "Rating" },
    [10] = { key = "ITEM_MOD_CRIT_RATING", type = "Rating" },
    [11] = { key = "ITEM_MOD_HASTE_RATING", type = "Rating" },
    [12] = { key = "ITEM_MOD_DEFENSE_SKILL_RATING", type = "Rating" },
    [13] = { key = "ITEM_MOD_BLOCK_RATING", type = "Rating" },
    [14] = { key = "ITEM_MOD_DODGE_RATING", type = "Rating" },
    [15] = { key = "ITEM_MOD_PARRY_RATING", type = "Rating" },
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
};

-- Used for ratings only, to look up the key to pass to GetEffectFromRating().
LB.ModToRating = {
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

LB.ContainsPercent = {
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
}
