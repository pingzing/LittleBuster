local addonName, LB = ...;

LB.enUS = {};

LB.enUS.Strings = {
    -- Blizzard is silly, and doesn't always use the strings pointed to by the 
    -- various X_MOD_STAT_NAME, especially in older gear. So, we have here a table of alternative things
    -- to try for each stat
    StatKeyAlternatives = {
        ["ITEM_MOD_HIT_RATING"] = { "Increases your hit rating by" },
        ["ITEM_MOD_HIT_MELEE_RATING"] = { "Increases your hit rating by" },
        ["ITEM_MOD_HIT_RANGED_RATING"] = { "Increases your hit rating by" },
        ["ITEM_MOD_CRIT_RATING"] = { "Increases your critical strike rating by" },
        ["ITEM_MOD_CRIT_MELEE_RATING"] = { "Increases your critical strike rating by" },
        ["ITEM_MOD_CRIT_RANGED_RATING"] = { "Increases your critical strike rating by" },
        ["ITEM_MOD_HASTE_RATING"] = { "Increases your haste rating by" },
        ["ITEM_MOD_EXPERTISE_RATING"] = { "Increases expertise rating by" },
        ["ITEM_MOD_HIT_SPELL_RATING"] = { "Increases your spell hit rating by" },
        ["ITEM_MOD_CRIT_SPELL_RATING"] = { "Increases your spell critical strike rating by" },
        ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { "Increases defense rating by" },
        ["ITEM_MOD_BLOCK_RATING"] = { "Increases your block rating by" },
        ["ITEM_MOD_DODGE_RATING"] = { "Increases dodge rating by" },
        ["ITEM_MOD_PARRY_RATING"] = {},
    },
    ShortStatPattern = " rating by (%d+)",
}
