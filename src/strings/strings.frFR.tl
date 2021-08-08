local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local frFR: LocaleTable = {};

frFR.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = {},
    ["ITEM_MOD_HIT_MELEE_RATING"] = {},
    ["ITEM_MOD_HIT_RANGED_RATING"] = {},
    ["ITEM_MOD_CRIT_RATING"] = {
        {pattern = "(%d+) le score de coup critique", location="AfterValue"},
        {pattern = "score de coup critique de (%d+)", location="AfterValue"},
        {pattern = "(%d+) au score de coup critique", location="AfterValue"}, -- gems
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
    ["ITEM_MOD_HASTE_RATING"] = {},
    ["ITEM_MOD_EXPERTISE_RATING"] = {
        {pattern = "(%d+) le score d’expertise", location="AfterValue"}, -- note the stupid curly apostrophe
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        {pattern = "score de toucher des sorts de (%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "(%d+) le score de coup critique des sorts", location="AfterValue"},
        {pattern = "(%d+) au score de critique des sorts", location="AfterValue"}, -- gems
        {pattern = "(%d+) au score de coup critique des sorts", location="AfterValue"},
        {pattern = "score de coup critique des sorts de (%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {},
    ["ITEM_MOD_BLOCK_RATING"] = {},
    ["ITEM_MOD_DODGE_RATING"] = {
        {pattern = "(%d+) le score d’esquive", location="AfterValue"}, -- note the stupid curly apostrophe
        {pattern = "(%d+) le score d'esquive", location="AfterValue"},
        {pattern = "score d'esquive de (%d+)", location="AfterValue"},
        {pattern = "(%d+) au score d'esquive", location="AfterValue"},
    },
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) agilité", location = "PatternEnd" },
        { pattern = "l'agilité.+de (%d+)", location = "AfterValue" },
        { pattern = "agilité de (%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+) intelligence", location = "PatternEnd" },
        { pattern = "l'intelligence.+de (%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_SPIRIT"] = {
        { pattern = "+(%d+) esprit", location = "PatternEnd" },
        { pattern = "l'esprit.+de (%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_STAMINA"] = {
        { pattern = "+(%d+) endurance", location = "PatternEnd" },
        { pattern = "l'endurance.+de (%d+)", location = "AfterValue" },
    },
};

-- These are tried second.
frFR.GetShortStatPatterns = function(shortStatString: string, _: string) : {SearchPattern}
    return {
        {pattern = "(%d+) le score de " .. shortStatString, location="AfterValue"},
        {pattern = "score de " .. shortStatString .. " augmenté de (%d+)", location="AfterValue"},
        {pattern = "score de ".. shortStatString .. " de (%d+)", location="AfterValue"},
        {pattern = "(%d+) au score de ".. shortStatString, location="AfterValue"}, -- mostly seen on gems
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

    AttributesHeader = "Attributes",
    AgilityCheckbox = "Scan for Agility and...",
    AgiDodgeCheck = "...display Dodge bonus",
    AgiCritCheck = "...display Crit bonus",
    AgiArmorCheck = "...display Armor bonus",
    AgiAPCheck = "...display Attack Power bonus",
    AgiRAPCheck = "...display Ranged Attack Power bonus",
    AgilityHealingCheckbox = "...display Healing bonus",

    IntellectCheckbox = "Scan for Intellect and...",
    IntellectManaCheckbox = "...display Mana bonus",
    IntellectSpellCritCheckbox = "...display Spell Crit bonus",
    IntellectSpellDamageCheckbox = "...display Spell Damage bonus",
    IntellectHealingCheckbox = "...display Healing bonus",
    IntellectManaRegenCheckbox = "...display Mana Regen bonus",
    IntellectRangedAPCheckbox = "...display Ranged Attack Power bonus",
    IntellectArmorCheckbox = "...display Armor bonus",

    SpiritCheckbox = "Scan for Spirit and...",
    SpiritManaRegenNotCastingCheckbox = "...display Mana Regen while not casting",
    SpiritManaRegenCastingCheckbox = "...display Mana Regen while casting",
    SpiritHealthRegenCheckbox = "...display Health Regen bonus",
    SpiritSpellDamageCheckbox = "...display Spell Damage bonus",
    SpiritHealingCheckbox = "...display Healing bonus",

    StaminaCheckbox = "Scan for Stamina and...",
    StaminaHealthCheckbox = "...display Health bonus",
    StaminaSpellDamageCheckbox = "...display Spell Damage bonus",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
frFR.StatStrings = {
    Dodge = "Dodge",
    Crit = "Crit",
    AttackPower = "AP",
    RangedAttackPower = "RAP",
    Armor = "Armor",

    Mana = "Mana",
    SpellCrit = "Spell Crit",
    SpellDamage = "Spell Damage",
    Healing = "Healing",
    ManaRegen = "MP5",

    Health = "HP",
    HealthRegen = "HP5"
}

LB.LocaleTables["frFR"] = {};
LB.LocaleTables["frFR"].getLocaleTable = function(): LocaleTable
    return frFR;
end
