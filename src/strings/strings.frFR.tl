local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local frFR: LocaleTable = {};

frFR.AlternativePatterns = {
    -- These patterns are tried first.
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
};

-- These are tried second.
frFR.GetShortStatPatterns = function(shortStatString: string, _: string) : {string}
    return {
        "(%d+) le score de " .. shortStatString,
        "score de " .. shortStatString .. " augmenté de (%d+)",
        "score de ".. shortStatString .. " de (%d+)",
        "(%d+) au score de ".. shortStatString, -- mostly seen on gems
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
frFR.ConfigStrings = {
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
frFR.StatStrings = {
    Dodge = "dodge",
}

LB.LocaleTables["frFR"] = {};
LB.LocaleTables["frFR"].getLocaleTable = function(): LocaleTable
    return frFR;
end
