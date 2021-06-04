local addonName, LB = ...;

LB.esMX = {};

LB.esMX.Strings = {
    -- Blizzard is silly, and doesn't always use the strings pointed to by the 
    -- various X_MOD_STAT_NAME, especially in older gear. So, we have here a table of alternative things
    -- to try for each stat
    -- Note that this table only gets used by statLineContains(), and NOT statLineContainsShortPattern().
    StatKeyAlternatives = {
        ["ITEM_MOD_HIT_RATING"] = {},
        ["ITEM_MOD_HIT_MELEE_RATING"] = {},
        ["ITEM_MOD_HIT_RANGED_RATING"] = {},
        ["ITEM_MOD_CRIT_RATING"] = {},
        ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
        ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
        ["ITEM_MOD_HASTE_RATING"] = {},
        ["ITEM_MOD_EXPERTISE_RATING"] = {},
        ["ITEM_MOD_HIT_SPELL_RATING"] = {},
        ["ITEM_MOD_CRIT_SPELL_RATING"] = {},
        ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
            "Aumenta el índice de defensa en", "Aumenta el índice de defensa",
        },
        ["ITEM_MOD_BLOCK_RATING"] = {},
        ["ITEM_MOD_DODGE_RATING"] = {},
        ["ITEM_MOD_PARRY_RATING"] = { "Aumenta tu índice de parada" },
    },
}

-- Possible short stat patterns we might see in trinkets, or set bonuses.
function LB.esMX.GetShortStatPatterns(shortStatString)
    -- Pay VERY close attention to the accent over the i.
    -- it is actually í and not i.
    return {
        " índice de " .. shortStatString .. " (%d+) p.",
        "(%d+) p. tu índice de " .. shortStatString,
    };
end
