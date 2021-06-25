local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local zhTW: LocaleTable = {};

zhTW.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = {
        { pattern = "命中等級提高(%d+點)", location = "AfterValue" },
        { pattern = "(%d+點)物理命中等級", location = "AfterValue" },
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {},
    ["ITEM_MOD_HIT_RANGED_RATING"] = {},
    ["ITEM_MOD_CRIT_RATING"] = {
        { pattern = "致命一擊等級提高(%d+點)", location = "AfterValue" },
        { pattern = "提高(%d+點)致命一擊", location = "AfterValue" },
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {},
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {},
    ["ITEM_MOD_HASTE_RATING"] = {},
    ["ITEM_MOD_EXPERTISE_RATING"] = {},
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        { pattern = "提高(%d+點)法術命中。", location = "AfterValue" },
        { pattern = "(%d+)法術命中等級", location = "AfterValue" },
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        { pattern = "提高(%d+點)法術致命一擊。", location = "AfterValue" },
        { pattern = "(%d+)法術致命一擊等級", location = "AfterValue" },
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
        { pattern = "(%d+防禦等級)", location = "AfterValue" },
    },
    ["ITEM_MOD_BLOCK_RATING"] = {
        { pattern = "格擋值提高(%d+點)", location = "AfterValue" },
        { pattern = "格擋等級提高(%d+點)", location = "AfterValue" },
    },
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+)敏捷", location = "PatternEnd" },
    },
    ["ITEM_MOD_INTELLECT"] = {}
}

-- These are tried second.
zhTW.GetShortStatPatterns = function(shortStatString: string, statKey: string): {SearchPattern}
    return {
        { pattern = "提高(%d+點)" .. shortStatString .. "。" , location = "AfterValue" },
        { pattern = "提高" .. shortStatString .. "(%d+點)。", location = "AfterValue" },
        { pattern = "+(%d+)" .. shortStatString .. "等級" , location = "AfterValue" },
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
zhTW.ConfigStrings = {
    DefensesHeader = "防禦屬性",
    DefenseRatingCheckbox = "顯示轉換後的防禦等級",
    DodgeRatingCheckbox = "顯示轉換後的閃避等級",
    ParryRatingCheckbox = "顯示轉後後的招架等級",
    BlockRatingCheckbox = "顯示轉換後的格擋等級",
 
    SpellsHeader = "法術屬性",
    SpellHitRatingCheckbox = "顯示轉換後的法術命中等級",
    SpellCritRatingCheckbox = "顯示轉換後的法術爆擊等級",
    SpellHasteRatingCheckbox = "顯示轉換後的法術加速等級",
 
    PhysicalsHeader = "近戰及遠程屬性",
    PhysicalHitRatingCheckbox = "顯示轉換後的命中等級",
    PhysicalCritRatingCheckbx = "顯示轉換後的爆夠等級",
    PhysicalHasteRatingCheckbox = "顯示轉換後的加速等級",
    PhysicalExpertiseRatingCheckbox = "顯示轉換後的熟練等級",

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
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
zhTW.StatStrings = {
    Dodge = "閃躲",
    Crit = "致命一擊",
    AttackPower = "攻擊強度",
    RangedAttackPower = "遠程攻擊強度",
    Armor = "護甲",

    Mana = "Mana",
    SpellCrit = "Spell Crit",
    SpellDamage = "Spell Damage",
    Healing = "Healing",
    ManaRegen = "MP5",
}

LB.LocaleTables["zhTW"] = {};
LB.LocaleTables["zhTW"].getLocaleTable = function(): LocaleTable
    return zhTW;
end
