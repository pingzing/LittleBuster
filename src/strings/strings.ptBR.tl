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
        {pattern = "(%d+) sua taxa de acerto de feitiços", location = "AfterValue"},
        {pattern = "(%d+) a taxa de acerto de feitiços", location = "AfterValue"},
        {pattern = "(%d+) taxa de acerto de feitiço", location = "AfterValue"},
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "(%d+) a taxa de acerto crítico de feitiços", location = "AfterValue"},
        {pattern = "(%d+) a taxa de de acerto crítico de feitiços", location = "AfterValue"}, -- typo in Adept's Elixir
        {pattern = "(%d+) taxa de acerto crítico de feitiço", location = "AfterValue"},
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {},
    ["ITEM_MOD_BLOCK_RATING"] = {},
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) agilidade", location = "PatternEnd" },
        { pattern = "(%d+) a agilidade", location = "AfterValue" },
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+) intelecto", location = "PatternEnd" },
        { pattern = "(%d+) o.+intelecto", location = "PatternEnd" },
    },
    ["ITEM_MOD_SPIRIT"] = {
        { pattern = "+(%d+) espírito", location = "PatternEnd" },
        { pattern = "(%d+) o.+espírito", location = "PatternEnd" },
    },
    ["ITEM_MOD_STAMINA"] = {
        { pattern = "+(%d+) vigor", location = "PatternEnd" },
        { pattern = "(%d+) o.+vigor", location = "AfterValue" },
    },
}

-- These are tried second.
ptBR.GetShortStatPatterns = function(shortStatString: string, _: string) : {SearchPattern}
    return {
        {pattern = "(%d+) a taxa de "..shortStatString, location = "AfterValue"},
        {pattern = "(%d+) a sua taxa de "..shortStatString, location = "AfterValue"},
        {pattern = "(%d+) de taxa de "..shortStatString, location = "AfterValue"},
        {pattern = "(%d+) sua taxa de "..shortStatString, location = "AfterValue"},
        {pattern = "(%d+) taxa de "..shortStatString, location = "AfterValue"}, -- gems, mostly
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
ptBR.StatStrings = {
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

LB.LocaleTables["ptBR"] = {};
LB.LocaleTables["ptBR"].getLocaleTable = function(): LocaleTable
    return ptBR;
end
