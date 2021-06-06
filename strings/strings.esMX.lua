local addonName, LB = ...;

local esMX = {};

-- Also used for esES.

-- A HUGE number of esMX tooltips, especially for pre-TBC gear are just... wrong.
-- Wrong in a way that is 100% not worth it to try to support. TBC patterns only here!

-- Note: For many of these, we want to make sure that we don't insert our value between the actual
-- rating number and the 'p.' ('puntos', probably), so we include the 'p.' inside our captures.
-- We have to escape the dot with a percent sign though, and have to write it out as 'p%.'

esMX.Strings = {
    -- These patterns are tried first.
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

-- These are tried second.
function esMX.GetShortStatPatterns(shortStatString, statKey)
    -- Pay VERY close attention to the accent over the i.
    -- it is actually í and not i.
    return {
        "índice de " .. shortStatString .. " (%d+ p%.)",
        "índice de " .. shortStatString .. " en (%d+ p%.)",
        "(%d+ p%.) tu índice de " .. shortStatString,
        "(%d+ p%.) de índice de " .. shortStatString,
    };
end

LB.esMX = {};
function LB.esMX.getLocaleTable()
    return esMX;
end
