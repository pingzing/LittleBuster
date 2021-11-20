local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local enUS: LocaleTable = {};

enUS.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = { 
        {pattern = "increases your hit rating by (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        {pattern = "increases your hit rating by (%d+).", location = "AfterValue"},
        {pattern = "melee hit rating by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        {pattern = "increases your hit rating by (%d+).", location = "AfterValue"},
        {pattern = "ranged hit rating by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        {pattern = "increases your critical strike rating by (%d+).", location = "AfterValue"},
        {pattern = "critical strike rating by (%d+)", location = "AfterValue"},
        {pattern = "crit rating by (%d+)", location = "AfterValue"},
        {pattern = "(%d+) critical rating", location = "AfterValue"}, -- Seen on gems, mostly
        {pattern = "(%d+) crit rating", location = "AfterValue"}, -- occasionally seen on gems
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        {pattern = "increases your critical strike rating by (%d+).", location = "AfterValue"},
        {pattern = "melee critical strike rating by (%d+)", location = "AfterValue"},
        {pattern = "melee crit rating by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        {pattern = "increases your critical strike rating by (%d+).", location = "AfterValue"},
        {pattern = "ranged crit rating by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_HASTE_RATING"] = { 
        {pattern = "increases your haste rating by (%d+).", location = "AfterValue"},  
    },
    ["ITEM_MOD_EXPERTISE_RATING"] = { 
        {pattern = "increases expertise rating by (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        {pattern = "increases your spell hit rating by (%d+).", location = "AfterValue"},
        {pattern = "spell hit rating by (%d+)", location = "AfterValue"},
        {pattern = "(%d+) spell hit rating", location = "AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "increases your spell critical strike rating by (%d+).", location = "AfterValue"},
        {pattern = "spell critical strike rating by (%d+)", location = "AfterValue"},
        {pattern = "spell crit rating by (%d+)", location = "AfterValue"},
        {pattern = "(%d+) spell critical strike rating", location = "AfterValue"},
        {pattern = "(%d+) spell critical rating", location = "AfterValue"},
        {pattern = "(%d+) spell crit rating", location = "AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = { 
        {pattern = "spell haste rating by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { 
        {pattern = "increases defense rating by (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_BLOCK_RATING"] = { 
        {pattern = "increases your block rating by (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_DODGE_RATING"] = { 
        {pattern = "increases dodge rating by (%d+).", location = "AfterValue"},
        {pattern ="(%d+) dodge rating", location = "AfterValue"},
    },
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        {pattern = "+(%d+) agility", location = "PatternEnd"},
        {pattern = "agility by (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+) intellect", location = "PatternEnd" },
        { pattern = "intellect.+by (%d+)", location = "AfterValue" }
    },
    ["ITEM_MOD_SPIRIT"] = {
        { pattern = "+(%d+) spirit", location = "PatternEnd" },
        { pattern = "spirit.+by (%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_STAMINA"] = {
        { pattern = "+(%d+) stamina", location = "PatternEnd" },
        { pattern = "stamina.+by (%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_STRENGTH"] = {
        { pattern = "+(%d+) strength", location = "PatternEnd" },
        { pattern = "strength.+by (%d+)", location = "AfterValue" },
    }
}

-- These are tried second.
enUS.GetShortStatPatterns = function(shortStatString: string, _statKey: string): {SearchPattern}
    return {
        {pattern = shortStatString .. " rating by (%d+)", location = "AfterValue"},
        { pattern ="(%d+) " .. shortStatString .. " rating", location = "AfterValue"},
        { pattern ="+(%d+) " .. shortStatString, location = "AfterValue"},
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
enUS.ConfigStrings = {
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

    StrengthCheckbox = "Scan for Strength and...",
    StrengthAttackPowerCheckbox = "...display Attack Power bonus",
    StrengthBlockValueCheckbox = "...display Block Value bonus",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
enUS.StatStrings = {
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
    HealthRegen = "HP5",

    BlockValue = "Block Value",
}

LB.LocaleTables["enUS"] = {};
LB.LocaleTables["enUS"].getLocaleTable = function(): LocaleTable
    return enUS;
end
