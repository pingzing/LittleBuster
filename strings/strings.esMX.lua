local args = { ... };
local LB = args[2];

local esMX = {};










esMX.Strings = {

   AlternativePatterns = {
      ["ITEM_MOD_HIT_RATING"] = { "(%d+ p%.) el golpe.", "(%d+) índice de golpe" },
      ["ITEM_MOD_HIT_MELEE_RATING"] = {},
      ["ITEM_MOD_HIT_RANGED_RATING"] = {},
      ["ITEM_MOD_CRIT_RATING"] = {
         "(%d+ p%.) el golpe crítico.",
         "(%d+) índice de golpe crítico",
      },
      ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
      ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
      ["ITEM_MOD_HASTE_RATING"] = {},
      ["ITEM_MOD_EXPERTISE_RATING"] = {},
      ["ITEM_MOD_HIT_SPELL_RATING"] = { "índice de golpe con hechizos en (%d+ p%.)" },
      ["ITEM_MOD_CRIT_SPELL_RATING"] = {
         "(%d+ p%.) el golpe crítico con hechizos",
         "(%d+) índice de golpe crítico con hechizos",
         "índice de golpe crítico con hechizos en (%d+ p%.)",
      },
      ["ITEM_MOD_HASTE_SPELL_RATING"] = {
         "índice de celeridad con hechizos (%d+ p%.)",
         "índice de celeridad con hechizos en (%d+ p%.)",
      },
      ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
         "Aumenta el índice de defensa en (%d+ p%.)",
         "Aumenta el índice de defensa (%d+ p%.)",
         "(%d+ p%.) la defensa.",
         "(%d+) índice de defensa",
      },
      ["ITEM_MOD_BLOCK_RATING"] = {
         "índice de bloqueo con escudo en (%d+ p%.)",
         "índice de bloqueo en (%d+ p%.)",
         "(%d+ p%.) el bloqueo con escudo.",
      },
      ["ITEM_MOD_DODGE_RATING"] = {},
      ["ITEM_MOD_PARRY_RATING"] = { "Aumenta tu índice de parada" },
   },
}


esMX.GetShortStatPatterns = function(shortStatString, _)


   return {
      "índice de " .. shortStatString .. " (%d+ p%.)",
      "índice de " .. shortStatString .. " en (%d+ p%.)",
      "(%d+ p%.) tu índice de " .. shortStatString,
      "(%d+ p%.) de índice de " .. shortStatString,
   }
end

LB.LocaleTables["esMX"] = {};
LB.LocaleTables["esMX"].getLocaleTable = function()
   return esMX
end
