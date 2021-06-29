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
        { pattern = "(%d+)防禦等級", location = "AfterValue" },
        { pattern = "防禦等級提高(%d+點)", location = "AfterValue" },
        { pattern = "提高(%d+點)防禦", location = "AfterValue" },
        { pattern = "(%d+點)防禦等級", location = "AfterValue" },
    },
    ["ITEM_MOD_BLOCK_RATING"] = {
        { pattern = "提高(%d+點)盾牌格擋", location = "AfterValue" },
        { pattern = "格擋等級提高(%d+點)", location = "AfterValue" },
    },
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+)敏捷", location = "PatternEnd" },
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+)智力", location = "PatternEnd" },
        { pattern = "智力.+(%d+)", location = "AfterValue" },
    }
}

-- These are tried second.
zhTW.GetShortStatPatterns = function(shortStatString: string, _: string): {SearchPattern}
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

    AttributesHeader = "基本屬性",
    AgilityCheckbox = "敏捷...",
    AgiDodgeCheck = "...顯示閃躲加成",
    AgiCritCheck = "...顯示致命加成",
    AgiArmorCheck = "...顯示護甲加成",
    AgiAPCheck = "...顯示攻擊強度加成",
    AgiRAPCheck = "...顯示遠程攻擊強度加成",
    AgilityHealingCheckbox = "...顯示治療加成",

    IntellectCheckbox = "智力...",
    IntellectManaCheckbox = "...顯示法力加成",
    IntellectSpellCritCheckbox = "...顯示法術致命加成",
    IntellectSpellDamageCheckbox = "...顯示法術傷害加成",
    IntellectHealingCheckbox = "...顯示治療加成",
    IntellectManaRegenCheckbox = "...顯示法力回複加成",
    IntellectRangedAPCheckbox = "...顯示遠程攻擊強度加成",
    IntellectArmorCheckbox = "...顯示護甲加成",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
zhTW.StatStrings = {
    Dodge = "閃躲",
    Crit = "致命一擊",
    AttackPower = "攻擊強度",
    RangedAttackPower = "遠程攻擊強度",
    Armor = "護甲",

    Mana = "法力",
    SpellCrit = "法術致命",
    SpellDamage = "法術傷害",
    Healing = "治療",
    ManaRegen = "MP5",
}

LB.LocaleTables["zhTW"] = {};
LB.LocaleTables["zhTW"].getLocaleTable = function(): LocaleTable
    return zhTW;
end
