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
    ["ITEM_MOD_PARRY_RATING"] = {
        { pattern = "使你的招架等级提高(%d+)", location = "AfterValue" },
        { pattern = "(%d+) 招架等级", location = "AfterValue" },
    },
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

    AttributesHeader = "属性",
    AgilityCheckbox = "扫描敏捷属性并且...",
    AgiDodgeCheck = "...显示闪躲收益",
    AgiCritCheck = "...显示暴击收益",
    AgiArmorCheck = "...显示护甲收益",
    AgiAPCheck = "...显示攻击强度收益(AP)",
    AgiRAPCheck = "...显示远程攻击强度收益(RAP)",
    AgilityHealingCheckbox = "...显示治疗收益",

    IntellectCheckbox = "扫描智力属性并且...",
    IntellectManaCheckbox = "...显示额外法力上限获得",
    IntellectSpellCritCheckbox = "...显示法术暴击收益",
    IntellectSpellDamageCheckbox = "...显示法术强度收益",
    IntellectHealingCheckbox = "...显示治疗效果收益",
    IntellectManaRegenCheckbox = "...显示魔法回复收益",
    IntellectRangedAPCheckbox = "...显示远程攻击强度(RAP)收益",
    IntellectArmorCheckbox = "...显示护甲收益",

    SpiritCheckbox = "扫描精神属性并且...",
    SpiritManaRegenNotCastingCheckbox = "...显示施法外五秒回复收益",
    SpiritManaRegenCastingCheckbox = "...显示施法中五秒回复收益",
    SpiritHealthRegenCheckbox = "...显示生命回复收益",
    SpiritSpellDamageCheckbox = "...显示法术伤害收益",
    SpiritHealingCheckbox = "...显示治疗效果收益",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
zhCN.StatStrings = {
    Dodge = "闪躲",
    Crit = "暴击",
    AttackPower = "AP",
    RangedAttackPower = "远程AP",
    Armor = "护甲",

    Mana = "法力",
    SpellCrit = "法暴",
    SpellDamage = "法术",
    Healing = "治疗效果",
    ManaRegen = "MP5",

   HealthRegen = "MP5"
}

LB.LocaleTables["zhCN"] = {};
LB.LocaleTables["zhCN"].getLocaleTable = function(): LocaleTable
    return zhCN;
end