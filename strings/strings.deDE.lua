local addonName, LB = ...;

local deDE = {};

deDE.Strings = {
    -- These patterns are tried first.
    AlternativePatterns = {
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
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {},
        ["ITEM_MOD_BLOCK_RATING"] = {},
        ["ITEM_MOD_DODGE_RATING"] = {},
        ["ITEM_MOD_PARRY_RATING"] = {},
    },
}

-- Because the German short stat strings are never used directly--just their conjugated forms x.x
local conjugatedShortStats = {
    ["ITEM_MOD_HIT_RATING"] = "treffer",
    ["ITEM_MOD_HIT_MELEE_RATING"] = "treffer",
    ["ITEM_MOD_HIT_RANGED_RATING"] = "treffer", -- does anything in the game actually give JUST ranged hit rating?
    ["ITEM_MOD_CRIT_RATING"] = "kritische treffer",
    ["ITEM_MOD_CRIT_MELEE_RATING"] = "kritische treffer", -- ditto just crit?
    ["ITEM_MOD_CRIT_RANGED_RATING"] = "kritische treffer", -- ditto just ranged crit?
    ["ITEM_MOD_HASTE_RATING"] = "tempo",
    ["ITEM_MOD_EXPERTISE_RATING"] = "waffenkunde",
    ["ITEM_MOD_HIT_SPELL_RATING"] = "zaubertreffer zaubertreffer",
    ["ITEM_MOD_CRIT_SPELL_RATING"] = "kritische",
    ["ITEM_MOD_HASTE_SPELL_RATING"] = "zaubertempo",
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = "verteidigungs",
    ["ITEM_MOD_BLOCK_RATING"] = "block",
    ["ITEM_MOD_DODGE_RATING"] = "ausweich",
    ["ITEM_MOD_PARRY_RATING"] = "parier",
}

-- These are tried second.
function deDE.GetShortStatPatterns(shortStatString, statKey)
    return {
        "(%d+) "..conjugatedShortStats[statKey], -- rarer proc format
        shortStatString .. "wertung um (%d+)",
        conjugatedShortStats[statKey] .. "wertung um (%d+)",
        conjugatedShortStats[statKey].."wertung %d+ sek. lang um (%d+)", -- see this a lot on procs, trinkets, etc
    };
end

LB.deDE = {};
function LB.deDE.getLocaleTable()
    return deDE;
end
