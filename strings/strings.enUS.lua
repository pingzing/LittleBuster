local addonName, LB = ...;

local enUS = {};

enUS.Strings = {
    -- These patterns are tried first.
    AlternativePatterns = {
        ["ITEM_MOD_HIT_RATING"] = { "increases your hit rating by (%d+)." },
        ["ITEM_MOD_HIT_MELEE_RATING"] = {
            "increases your hit rating by (%d+).",
            "melee hit rating by (%d+)",
        },
        ["ITEM_MOD_HIT_RANGED_RATING"] = {
            "increases your hit rating by (%d+).",
            "ranged hit rating by (%d+)",
        },
        ["ITEM_MOD_CRIT_RATING"] = {
            "increases your critical strike rating by (%d+).",
            "critical strike rating by (%d+)",
            "crit rating by (%d+)",
            "(%d+) critical rating", -- Seen on gems, mostly
        },
        ["ITEM_MOD_CRIT_MELEE_RATING"] = {
            "increases your critical strike rating by (%d+).",
            "melee critical strike rating by (%d+)",
            "melee crit rating by (%d+)",
        },
        ["ITEM_MOD_CRIT_RANGED_RATING"] = {
            "increases your critical strike rating by (%d+).",
            "ranged crit rating by (%d+)",
        },
        ["ITEM_MOD_HASTE_RATING"] = { "increases your haste rating by (%d+)." },
        ["ITEM_MOD_EXPERTISE_RATING"] = { "increases expertise rating by (%d+)." },
        ["ITEM_MOD_HIT_SPELL_RATING"] = {
            "increases your spell hit rating by (%d+).",
            "spell hit rating by (%d+)",
            "(%d+) spell hit rating", -- Seen on gems, mostly
        },
        ["ITEM_MOD_CRIT_SPELL_RATING"] = {
            "increases your spell critical strike rating by (%d+).",
            "spell critical strike rating by (%d+)",
            "spell crit rating by (%d+)",
            "(%d+) spell critical strike rating",
            "(%d+) spell critical rating",
            "(%d+) spell crit rating", -- Seen on gems, mostly
        },
        ["ITEM_MOD_HASTE_SPELL_RATING"] = { "spell haste rating by (%d+)" },
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { "increases defense rating by (%d+)." },
        ["ITEM_MOD_BLOCK_RATING"] = { "increases your block rating by (%d+)." },
        ["ITEM_MOD_DODGE_RATING"] = { "increases dodge rating by (%d+).", "(%d+) dodge rating" },
        ["ITEM_MOD_PARRY_RATING"] = {},
    },
}

-- These are tried second.
function enUS.GetShortStatPatterns(shortStatString)
    return {
        shortStatString .. " rating by (%d+)", -- "...imcrase your parry rating by 72..."
        "(%d+) " .. shortStatString .. " rating", -- "...grant you 152 dodge rating..."
        "+(%d+) " .. shortStatString, -- +5 Agility or +5 Defense Rating
    };
end

LB.enUS = {};
function LB.enUS.getLocaleTable()
    return enUS;
end
