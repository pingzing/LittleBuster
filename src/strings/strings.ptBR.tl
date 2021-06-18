local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local ptBR: LocaleTable = {};

ptBR.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = {},
    ["ITEM_MOD_HIT_MELEE_RATING"] = {},
    ["ITEM_MOD_HIT_RANGED_RATING"] = {},
    ["ITEM_MOD_CRIT_RATING"] = {},
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
    ["ITEM_MOD_HASTE_RATING"] = {},
    ["ITEM_MOD_EXPERTISE_RATING"] = {},
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        "(%d+) sua taxa de acerto de feitiços",
        "(%d+) a taxa de acerto de feitiços",
        "(%d+) taxa de acerto de feitiço",
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        "(%d+) a taxa de acerto crítico de feitiços",
        "(%d+) taxa de acerto crítico de feitiço",
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {},
    ["ITEM_MOD_BLOCK_RATING"] = {},
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {},

}

-- These are tried second.
ptBR.GetShortStatPatterns = function(shortStatString: string, _: string) : {string}
    return {
        "(%d+) a taxa de "..shortStatString,
        "(%d+) a sua taxa de "..shortStatString,
        "(%d+) de taxa de "..shortStatString,
        "(%d+) sua taxa de "..shortStatString,
        "(%d+) taxa de "..shortStatString, -- gems, mostly
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
ptBR.ConfigStrings = {
    DefensesHeader = "Defensive Stats",
    DefenseRatingCheckbox = "Display converted Defense rating",
    DodgeRatingCheckbox = "Display converted Dodge rating",
    ParryRatingCheckbox = "Display converted Parry rating",
    BlockRatingCheckbox = "Display converted Block rating",

    SpellsHeader = "Spell Stats",
    SpellHitRatingCheckbox = "Display converted Spell Hit rating",
    SpellCritRatingCheckbox = "Display converted Spell Crit rating",
    SpellHasteRatingCheckbox = "Display converted Spell Haste rating",

    PhysicalsHeader = "Melee and Ranged Stats",
    PhysicalHitRatingCheckbox = "Display converted Hit rating",
    PhysicalCritRatingCheckbx = "Display converted Crit rating",
    PhysicalHasteRatingCheckbox = "Display converted Haste rating",
    PhysicalExpertiseRatingCheckbox = "Display converted Expertise rating",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
ptBR.StatStrings = {
    Dodge = "dodge",
}

LB.LocaleTables["ptBR"] = {};
LB.LocaleTables["ptBR"].getLocaleTable = function(): LocaleTable
    return ptBR;
end
