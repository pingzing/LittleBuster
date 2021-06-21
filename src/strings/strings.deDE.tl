local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local deDE: LocaleTable = {};

deDE.AlternativePatterns = {
-- These patterns are tried first.
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
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) beweglichkeit", location = "PatternEnd" }
    },
};

-- Because the German short stat strings are never used directly--just their conjugated forms x.x
local conjugatedShortStats: {string:string} = {
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
    ["ITEM_MOD_AGILITY"] = "beweglichkeit",
}

-- These are tried second.
deDE.GetShortStatPatterns = function(shortStatString: string, statKey: string) : {SearchPattern}
    return {
        {pattern = "(%d+) "..conjugatedShortStats[statKey], location = "AfterValue"}, -- rarer proc format
        {pattern = shortStatString .. "wertung um (%d+)", location = "AfterValue"},
        {pattern = conjugatedShortStats[statKey] .. "wertung um (%d+)", location = "AfterValue"},
        {pattern = conjugatedShortStats[statKey].."wertung %d+ sek. lang um (%d+)", location = "AfterValue"}, -- see this a lot on procs, trinkets, etc
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
deDE.ConfigStrings = {
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

    AttributesHeader = "Attributes",
    AgilityCheckbox = "Scan for Agility and...",
    AgiDodgeCheck = "...display Dodge bonus",
    AgiCritCheck = "...display Crit bonus",
    AgiArmorCheck = "...display Armor bonus",
    AgiAPCheck = "...display Attack Power bonus",
    AgiRAPCheck = "...display Ranged Attack Power bonus",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
deDE.StatStrings = {
    Dodge = "Dodge",
    Crit = "Crit",
    AttackPower = "AP",
    RangedAttackPower = "RAP",
    Armor = "Armor",
}

LB.LocaleTables["deDE"] = {};
LB.LocaleTables["deDE"].getLocaleTable = function(): LocaleTable
    return deDE;
end
