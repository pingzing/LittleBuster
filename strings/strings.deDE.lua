local args = { ... };
local LB = args[2];

local deDE = {};

deDE.Strings = {

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


local conjugatedShortStats = {
   ["ITEM_MOD_HIT_RATING"] = "treffer",
   ["ITEM_MOD_HIT_MELEE_RATING"] = "treffer",
   ["ITEM_MOD_HIT_RANGED_RATING"] = "treffer",
   ["ITEM_MOD_CRIT_RATING"] = "kritische treffer",
   ["ITEM_MOD_CRIT_MELEE_RATING"] = "kritische treffer",
   ["ITEM_MOD_CRIT_RANGED_RATING"] = "kritische treffer",
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


deDE.GetShortStatPatterns = function(shortStatString, statKey)
   return {
      "(%d+) " .. conjugatedShortStats[statKey],
      shortStatString .. "wertung um (%d+)",
      conjugatedShortStats[statKey] .. "wertung um (%d+)",
      conjugatedShortStats[statKey] .. "wertung %d+ sek. lang um (%d+)",
   }
end

LB.LocaleTables["deDE"] = {};
LB.LocaleTables["deDE"].getLocaleTable = function()
   return deDE
end
