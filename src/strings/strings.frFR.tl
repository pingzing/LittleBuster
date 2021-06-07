local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local frFR: LocaleTable = {};

frFR.Strings = {
    -- These patterns are tried first.
    AlternativePatterns = {
        ["ITEM_MOD_HIT_RATING"] = {},
        ["ITEM_MOD_HIT_MELEE_RATING"] = {},
        ["ITEM_MOD_HIT_RANGED_RATING"] = {},
        ["ITEM_MOD_CRIT_RATING"] = {
            "(%d+) le score de coup critique",
            "score de coup critique de (%d+)",
            "(%d+) au score de coup critique", -- gems
        },
        ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
        ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
        ["ITEM_MOD_HASTE_RATING"] = {},
        ["ITEM_MOD_EXPERTISE_RATING"] = {
            "(%d+) le score d’expertise" -- note the stupid curly apostrophe
        },
        ["ITEM_MOD_HIT_SPELL_RATING"] = {
            "score de toucher des sorts de (%d+)",
        },
        ["ITEM_MOD_CRIT_SPELL_RATING"] = {
            "(%d+) le score de coup critique des sorts",
            "(%d+) au score de critique des sorts", -- gems
            "(%d+) au score de coup critique des sorts",
            "score de coup critique des sorts de (%d+)"
        },
        ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {},
        ["ITEM_MOD_BLOCK_RATING"] = {},
        ["ITEM_MOD_DODGE_RATING"] = {
            "(%d+) le score d’esquive", -- note the stupid curly apostrophe
            "(%d+) le score d'esquive",
            "score d'esquive de (%d+)",
            "(%d+) au score d'esquive",
        },
        ["ITEM_MOD_PARRY_RATING"] = {},
    },
}

-- These are tried second.
frFR.GetShortStatPatterns = function(shortStatString: string, _: string) : {string}
    return {
        "(%d+) le score de " .. shortStatString,
        "score de " .. shortStatString .. " augmenté de (%d+)",
        "score de ".. shortStatString .. " de (%d+)",
        "(%d+) au score de ".. shortStatString, -- mostly seen on gems
    };
end

LB.LocaleTables["frFR"] = {};
LB.LocaleTables["frFR"].getLocaleTable = function(): LocaleTable
    return frFR;
end
