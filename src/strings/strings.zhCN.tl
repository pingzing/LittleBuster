local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local zhCN: LocaleTable = {};

zhCN.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = { 
        { pattern = "使你的命中等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        { pattern = "使你的命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "近战命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "近战命中等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        { pattern = "使你的命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "远程命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "命中等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        { pattern = "使你的爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "+(%d+)爆击", location = "AfterValue" }, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        { pattern = "使你的爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "近战爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "近战爆击等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        { pattern = "使你的爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "远程爆击等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_HASTE_RATING"] = { 
        { pattern = "使你的急速等级提高(%d+)", location = "AfterValue" }, 
    },
    ["ITEM_MOD_EXPERTISE_RATING"] = { 
        { pattern = "使你的精准等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        { pattern = "使你的法术命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "法术命中等级提高(%d+)", location = "AfterValue" },
        { pattern = "+(%d+) 法术命中等级", location = "AfterValue" }, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        { pattern = "使你的法术爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "法术爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "法术爆击等级提高(%d+)", location = "AfterValue" },
        { pattern = "(%d+) 法术爆击等级", location = "AfterValue" },
        { pattern = "(%d+) 法术爆击等级", location = "AfterValue" },
        { pattern = "+(%d+) 法术爆击等级", location = "AfterValue" }, -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = { 
        { pattern = "法术急速等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { 
        { pattern = "防御等级提高(%d+)", location = "AfterValue" },
    },
    ["ITEM_MOD_BLOCK_RATING"] = { 
        { pattern = "使你的盾牌格挡等级提高(%d+)", location = "AfterValue" },
        { pattern = "使你的盾牌格挡等级提高(%d+点)", location = "AfterValue" },
     },
    ["ITEM_MOD_DODGE_RATING"] = { 
        { pattern = "使你的躲闪等级提高(%d+)", location = "AfterValue" }, 
        { pattern = "(%d+) 躲闪等级", location = "AfterValue" },
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
    },
    ["ITEM_MOD_STAMINA"] = {
        { pattern = "+(%d+) 耐力", location = "PatternEnd" },
        { pattern = "耐力提高(%d+点)", location = "AfterValue" },
        { pattern = "(%d+点)耐力", location = "PatternEnd" },
        { pattern = "耐力.+高(%d+点)", location = "PatternEnd" },
    },
    ["ITEM_MOD_STRENGTH"] = {
        { pattern = "+(%d+) 力量", location = "PatternEnd" },
        { pattern = "力量提高(%d+点)", location = "AfterValue" },
        { pattern = "(%d+点)力量", location = "PatternEnd" },
        { pattern = "力量.+高(%d+点)", location = "PatternEnd" },
    }
}

-- These are tried second.
zhCN.GetShortStatPatterns = function(shortStatString: string, _statKey: string): {SearchPattern}
    return {
        { pattern = shortStatString .. "等级提高(%d+点)", location = "AfterValue" },
        { pattern = shortStatString .. "等级提高(%d+)", location = "AfterValue" },
        { pattern = "(%d+) " .. shortStatString .. " 等级", location = "AfterValue" },
        { pattern = "+(%d+) " .. shortStatString, location = "AfterValue" },
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
    AgilityCheckbox = "扫描敏捷性和...",
    AgiDodgeCheck = "...显示闪避加成",
    AgiCritCheck = "...显示暴击加成",
    AgiArmorCheck = "...显示护甲加成",
    AgiAPCheck = "...显示攻强加成",
    AgiRAPCheck = "...显示远程攻击强度加成",
    AgilityHealingCheckbox = "...显示治疗加成",
    
    IntellectCheckbox = "扫描智力和...",
    IntellectManaCheckbox = "...显示法力加成",
    IntellectSpellCritCheckbox = "...显示法术暴击加成",
    IntellectSpellDamageCheckbox = "...显示法术伤害加成",
    IntellectHealingCheckbox = "...显示治疗加成",
    IntellectManaRegenCheckbox = "...显示法力回复加成",
    IntellectRangedAPCheckbox = "...显示远程攻击强度加成",
    IntellectArmorCheckbox = "...显示护甲加成",
    
    SpiritCheckbox = "扫描精神和...",
    SpiritManaRegenNotCastingCheckbox = "...显示未施法时法力回复",
    SpiritManaRegenCastingCheckbox = "...显示施法时法力回复",
    SpiritHealthRegenCheckbox = "...显示生命恢复加成",
    SpiritSpellDamageCheckbox = "...显示法术伤害加成",
    SpiritHealingCheckbox = "...显示治疗加成", 

    StaminaCheckbox = "Scan for Stamina and...",
    StaminaHealthCheckbox = "...display Health bonus",
    StaminaSpellDamageCheckbox = "...display Spell Damage bonus",

    StrengthCheckbox = "Scan for Strength and...",
    StrengthAttackPowerCheckbox = "...display Attack Power bonus",
    StrengthBlockValueCheckbox = "...display Block Value bonus",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
zhCN.StatStrings = {
    Dodge = "躲闪",
    Crit = "暴击",
    AttackPower = "攻强",
    RangedAttackPower = "远程攻强",
    Armor = "护甲",
    
    Mana = "法力",
    SpellCrit = "法术暴击",
    SpellDamage = "法术伤害",
    Healing = "治疗",
    ManaRegen = "每5秒法力回复",
    
    Health = "HP",
    HealthRegen = "每5秒生命回复",

    BlockValue = "Block Value",
}

LB.LocaleTables["zhCN"] = {};
LB.LocaleTables["zhCN"].getLocaleTable = function(): LocaleTable
    return zhCN;
end