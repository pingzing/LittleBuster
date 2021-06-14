local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local zhCN: LocaleTable = {};

zhCN.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = { "使你的命中等级提高(%d+)" },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        "使你的命中等级提高(%d+)",
        "近战命中等级提高(%d+)",
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        "使你的命中等级提高(%d+)",
        "远程命中等级提高(%d+)",
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        "使你的爆击等级提高(%d+)",
        "爆击等级提高(%d+)",
        "爆击等级提高(%d+)",
        "+(%d+)爆击", -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        "使你的爆击等级提高(%d+)",
        "近战爆击等级提高(%d+)",
        "近战爆击等级提高(%d+)",
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        "使你的爆击等级提高(%d+)",
        "远程爆击等级提高(%d+)",
    },
    ["ITEM_MOD_HASTE_RATING"] = { "使你的急速等级提高(%d+)" },
    ["ITEM_MOD_EXPERTISE_RATING"] = { "使你的精准等级提高(%d+)" },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        "使你的法术命中等级提高(%d+)",
        "法术命中等级提高(%d+)",
        "+(%d+) 法术命中等级", -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        "使你的法术爆击等级提高(%d+)",
        "法术爆击等级提高(%d+)",
        "法术爆击等级提高(%d+)",
        "(%d+) 法术爆击等级",
        "(%d+) 法术爆击等级",
        "+(%d+) 法术爆击等级", -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = { "法术急速等级提高(%d+)" },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = { "使你的防御等级提高(%d+)" },
    ["ITEM_MOD_BLOCK_RATING"] = { "使你的盾牌格挡值提高(%d+)" },
    ["ITEM_MOD_DODGE_RATING"] = { 
        "使你的躲闪等级提高(%d+)", 
        "(%d+) 躲闪等级" 
    },
    ["ITEM_MOD_PARRY_RATING"] = {},
}

-- These are tried second.
zhCN.GetShortStatPatterns = function(shortStatString: string, _: string): {string}
    return {
        shortStatString .. "等级提高(%d+)", -- "...imcrase your parry rating by 72..."
        "(%d+) " .. shortStatString .. " 等级", -- "...grant you 152 dodge rating..."
        "+(%d+) " .. shortStatString, -- +5 Agility or +5 Defense Rating
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
};

LB.LocaleTables["zhCN"] = {};
LB.LocaleTables["zhCN"].getLocaleTable = function(): LocaleTable
    return zhCN;
end