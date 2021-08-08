local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local esMX: LocaleTable = {};

-- Also used for esES.

-- A HUGE number of esMX tooltips, especially for pre-TBC gear are just... wrong.
-- Wrong in a way that is 100% not worth it to try to support. TBC patterns only here!

-- Note: For many of these, we want to make sure that we don't insert our value between the actual
-- rating number and the 'p.' ('puntos', probably), so we include the 'p.' inside our captures.
-- We have to escape the dot with a percent sign though, and have to write it out as 'p%.'

esMX.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = { 
        {pattern = "(%d+ p%.) el golpe.", location="AfterValue"}, 
        {pattern = "(%d+) índice de golpe", location="AfterValue"}, 
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {},
    ["ITEM_MOD_HIT_RANGED_RATING"] = {},
    ["ITEM_MOD_CRIT_RATING"] = {
        {pattern = "(%d+ p%.) el golpe crítico.", location="AfterValue"},
        {pattern = "(%d+) índice de golpe crítico", location="AfterValue"},
        {pattern = "índice de golpes críticos en (%d+ p%.)", location="AfterValue"},
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
    ["ITEM_MOD_HASTE_RATING"] = {},
    ["ITEM_MOD_EXPERTISE_RATING"] = {},
    ["ITEM_MOD_HIT_SPELL_RATING"] = { 
        {pattern = "índice de golpe con hechizos en (%d+ p%.)", location="AfterValue"}, 
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "(%d+ p%.) el golpe crítico con hechizos", location="AfterValue"},
        {pattern = "(%d+) índice de golpe crítico con hechizos", location="AfterValue"},
        {pattern = "índice de golpe crítico con hechizos en (%d+ p%.)", location="AfterValue"},
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {
        {pattern = "índice de celeridad con hechizos (%d+ p%.)", location="AfterValue"},
        {pattern = "índice de celeridad con hechizos en (%d+ p%.)", location="AfterValue"},
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
        {pattern = "Aumenta el índice de defensa en (%d+ p%.)", location="AfterValue"},
        {pattern = "Aumenta el índice de defensa (%d+ p%.)", location="AfterValue"},
        {pattern = "(%d+ p%.) la defensa.", location="AfterValue"},
        {pattern = "(%d+) índice de defensa", location="AfterValue"},
    },
    ["ITEM_MOD_BLOCK_RATING"] = {
        {pattern = "índice de bloqueo con escudo en (%d+ p%.)", location="AfterValue"},
        {pattern = "índice de bloqueo en (%d+ p%.)", location="AfterValue"},
        {pattern = "(%d+ p%.) el bloqueo con escudo.", location="AfterValue"},
    },
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) agilidad", location = "PatternEnd" },
        { pattern = "(%d+ p%.) la agilidad", location = "AfterValue" },
        { pattern = "agilidad en (%d+ p%.)", location = "AfterValue" },
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+) intelecto", location = "PatternEnd" },
        { pattern = "intelecto.+ (%d+ p%.)", location = "AfterValue" },
        { pattern = "(%d+ p%.) el intelecto", location = "AfterValue" },
    },
    ["ITEM_MOD_SPIRIT"] = {
        { pattern = "+(%d+) espíritu", location = "PatternEnd" },
        { pattern = "espíritu.+ (%d+ p%.)", location = "AfterValue" },
    },
    ["ITEM_MOD_STAMINA"] = {
        { pattern = "+(%d+) aguante", location = "PatternEnd" },
        { pattern = "aguante.+ (%d+)", location = "AfterValue" },
    },
};

-- These are tried second.
esMX.GetShortStatPatterns = function(shortStatString: string, _: string): {SearchPattern}
    -- Pay VERY close attention to the accent over the i.
    -- it is actually í and not i.
    return {
        {pattern = "índice de " .. shortStatString .. " (%d+ p%.)", location="AfterValue"},
        {pattern = "índice de " .. shortStatString .. " en (%d+ p%.)", location="AfterValue"},
        {pattern = "(%d+ p%.) tu índice de " .. shortStatString, location="AfterValue"},
        {pattern = "(%d+ p%.) de índice de " .. shortStatString, location="AfterValue"},
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
esMX.ConfigStrings = {
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
esMX.StatStrings = {
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

LB.LocaleTables["esMX"] = {};
LB.LocaleTables["esMX"].getLocaleTable = function(): LocaleTable
    return esMX;
end
