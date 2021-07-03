local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local zhCN: LocaleTable = {};

zhCN.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = { 
        {pattern = "使你的命中等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        {pattern = "使你的命中等级提高(%d+)", location="AfterValue"},
        {pattern = "近战命中等级提高(%d+)", location="AfterValue"},
        {pattern = "命中等级提高(%d+)", location="AfterValue"},
        {pattern = "近战命中等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        {pattern = "使你的命中等级提高(%d+)", location="AfterValue"},
        {pattern = "远程命中等级提高(%d+)", location="AfterValue"},
        {pattern = "命中等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        {pattern = "使你的爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "+(%d+)爆击", location="AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        {pattern = "使你的爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "近战爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "近战爆击等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        {pattern = "使你的爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "远程爆击等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_HASTE_RATING"] = { 
        {pattern = "使你的急速等级提高(%d+)", location="AfterValue"}, 
    },
    ["ITEM_MOD_EXPERTISE_RATING"] = { 
        {pattern = "使你的精准等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        {pattern = "使你的法术命中等级提高(%d+)", location="AfterValue"},
        {pattern = "法术命中等级提高(%d+)", location="AfterValue"},
        {pattern = "+(%d+) 法术命中等级", location="AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "使你的法术爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "法术爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "法术爆击等级提高(%d+)", location="AfterValue"},
        {pattern = "(%d+) 法术爆击等级", location="AfterValue"},
        {pattern = "(%d+) 法术爆击等级", location="AfterValue"},
        {pattern = "+(%d+) 法术爆击等级", location="AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = { 
        {pattern = "法术急速等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { 
        {pattern = "防御等级提高(%d+)", location="AfterValue"},
    },
    ["ITEM_MOD_BLOCK_RATING"] = { 
        {pattern = "使你的盾牌格挡值提高(%d+)", location="AfterValue"},
        {pattern = "使你的盾牌格挡值提高(%d+点)", location="AfterValue"},
     },
    ["ITEM_MOD_DODGE_RATING"] = { 
        {pattern = "使你的躲闪等级提高(%d+)", location="AfterValue"}, 
        {pattern = "(%d+) 躲闪等级", location="AfterValue"},
    },
    ["ITEM_MOD_PARRY_RATING"] = {},
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) 敏捷", location = "PatternEnd" },
        { pattern = "敏捷.+高(%d+)点", location = "AfterValue"  },
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern ="+(%d+) 智力", location = "PatternEnd" },
        { pattern = "智力.+高(%d+点)", location = "AfterValue" },
    },
    ["ITEM_MOD_SPIRIT"] = {
        { pattern = "+(%d+) 精神", location = "PatternEnd" },
        { pattern = "精神.+高(%d+点)", location = "AfterValue" },
    }
}

-- These are tried second.
zhCN.GetShortStatPatterns = function(shortStatString: string, _statKey: string): {SearchPattern}
    return {
        {pattern = shortStatString .. "等级提高(%d+点)", location = "AfterValue"},
        {pattern = shortStatString .. "等级提高(%d+)", location = "AfterValue"},
        {pattern = "(%d+) " .. shortStatString .. " 等级", location = "AfterValue"},
        {pattern = "+(%d+) " .. shortStatString, location = "AfterValue"},
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
zhCN.ConfigStrings = {
    DefensesHeader = "防御属性",
    DefenseRatingCheckbox = "显示转换后的防御等级",
    DodgeRatingCheckbox = "显示转换后的闪避等级",
    ParryRatingCheckbox = "显示转换后的招架等级",
    BlockRatingCheckbox = "显示转换后的格挡等级",

    SpellsHeader = "法术属性",
    SpellHitRatingCheckbox = "显示转换后的法术命中等级",
    SpellCritRatingCheckbox = "显示转换后的法术爆击等级",
    SpellHasteRatingCheckbox = "显示转换后的法术急速等级",

    PhysicalsHeader = "近战和远程属性",
    PhysicalHitRatingCheckbox = "显示转换后的命中等级",
    PhysicalCritRatingCheckbx = "显示转换后的爆击等级",
    PhysicalHasteRatingCheckbox = "显示转换后的急速等级",
    PhysicalExpertiseRatingCheckbox = "显示转换后的精准等级",

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
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
zhCN.StatStrings = {
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

    HealthRegen = "HP5"
}

LB.LocaleTables["zhCN"] = {};
LB.LocaleTables["zhCN"].getLocaleTable = function(): LocaleTable
    return zhCN;
end