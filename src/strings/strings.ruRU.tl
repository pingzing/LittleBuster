local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local ruRU: LocaleTable = {};

ruRU.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = {
        {pattern = "рейтинг меткости на (%d+)", location = "AfterValue"},
        {pattern = "рейтинга меткости на (%d+)", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу меткости", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        {pattern = "рейтинг меткости на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        {pattern = "рейтинг меткости на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        {pattern = "рейтинг критического удара на (%d+).", location = "AfterValue"},
        {pattern = "критического урона на (%d+) ед.", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу критического удара", location = "AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        {pattern = "рейтинг критического удара на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        {pattern = "рейтинг критического удара на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_HASTE_RATING"] = {
        {pattern = "рейтинга скорости на (%d+) ед.", location = "AfterValue"},
        {pattern = "рейтинг скорости боя на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_EXPERTISE_RATING"] = {
        {pattern = "рейтинг мастерства на (%d+).", location = "AfterValue"},
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        {pattern = "меткость %(заклинания%) %+(%d+)", location = "AfterValue"}, -- Because consistency is for the weak. JFC.
        {pattern = "Повышение на (%d+)%% рейтинга меткости заклинаний.", location = "AfterValue"},
        { pattern = "+(%d+) к рейтингу меткости заклинаний", location = "AfterValue" } -- Gems
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        {pattern = "критический удар %(заклинания%) %+(%d+)", location = "AfterValue"}, -- screwwww consistencyyyyyyy
        {pattern = "повышает рейтинг критического эффекта заклинаний на (%d+)", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу критического эффекта заклинаний", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу критического удара заклинаниями", location = "AfterValue"}, -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {
        {pattern = "рейтинг скорости заклинаний на (%d+)", location = "AfterValue"},
        {pattern = "рейтингу скорости заклинаний на (%d+)", location = "AfterValue"},
        {pattern = "рейтинга скорости заклинаний на (%d+)", location = "AfterValue"},
        {pattern = "рейтинг скорости заклинаний (%d+) на", location = "AfterValue"},
        {pattern = "рейтингу скорости заклинаний (%d+) на", location = "AfterValue"},
        {pattern = "рейтинга скорости заклинаний (%d+) на", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу скорости заклинаний", location = "AfterValue"}, -- gems
        {pattern = "рейтинга скорости .+ (%d+ ед%.)", location = "AfterValue"}, -- This one is really broad--we look for "рейтинга скорости (SOME NUMBER OF ANY CHARACTER) (some number of digits) ед."
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
        {pattern = "повышает рейтинг защиты на (%d+).", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу защиты", location = "AfterValue"},
    },
    ["ITEM_MOD_BLOCK_RATING"] = {
        {pattern = "рейтинг блока на (%d+) ед.", location = "AfterValue"},
        {pattern = "рейтинг блокирования щитом на (%d+)", location = "AfterValue"},
        {pattern = "рейтинга блокирования щитом на (%d+)", location = "AfterValue"},
        {pattern = "рейтингу блокирования щитом на (%d+)", location = "AfterValue"},
    },
    ["ITEM_MOD_DODGE_RATING"] = {
        {pattern = "рейтинг уклонения (%d+ ед%.)", location = "AfterValue"},
        {pattern = "рейтинга уклонения (%d+ ед%.)", location = "AfterValue"},
        {pattern = "рейтингу уклонения (%d+ ед%.)", location = "AfterValue"},
        {pattern = "+(%d+) к рейтингу уклонения", location = "AfterValue"},
    },
    ["ITEM_MOD_PARRY_RATING"] = {
        {pattern = "+(%d+) к рейтингу парирования", location = "AfterValue"},
        {pattern = "рейтинга парирования атак на (%d+) ед.", location = "AfterValue"},
    },
    ["ITEM_MOD_AGILITY"] = {
        { pattern = "+(%d+) к ловкости", location = "PatternEnd" },
        { pattern = "ловкости на (%d+)", location = "AfterValue" }
    },
    ["ITEM_MOD_INTELLECT"] = {
        { pattern = "+(%d+) к интеллекту", location = "PatternEnd" },
        { pattern = "интеллекта.+(%d+ ед%.)", location = "AfterValue" },

    }
};

-- Because the Russian short stat strings are never used directly--just the conjugated forms
local conjugatedShortStats: {string:string} = {
    ["ITEM_MOD_HIT_RATING"] = "меткости",
    ["ITEM_MOD_HIT_MELEE_RATING"] = "меткости",
    ["ITEM_MOD_HIT_RANGED_RATING"] = "меткости", -- does anything in the game actually give JUST ranged hit rating?
    ["ITEM_MOD_CRIT_RATING"] = "критического удара",
    ["ITEM_MOD_CRIT_MELEE_RATING"] = "критического удара", -- ditto just crit?
    ["ITEM_MOD_CRIT_RANGED_RATING"] = "критического удара", -- ditto just ranged crit?
    ["ITEM_MOD_HASTE_RATING"] = "скорости",
    ["ITEM_MOD_EXPERTISE_RATING"] = "мастерства",
    ["ITEM_MOD_HIT_SPELL_RATING"] = "меткости заклинаний",
    ["ITEM_MOD_CRIT_SPELL_RATING"] = "критического удара заклинаниями",
    ["ITEM_MOD_HASTE_SPELL_RATING"] = "скорости заклинаний",
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = "защиты",
    ["ITEM_MOD_BLOCK_RATING"] = "блока",
    ["ITEM_MOD_DODGE_RATING"] = "уклонения",
    ["ITEM_MOD_PARRY_RATING"] = "парирования",
    ["ITEM_MOD_AGILITY"] = "ловкости",
    ["ITEM_MOD_INTELLECT"] = "интеллекту"
}

-- These are tried second.
ruRU.GetShortStatPatterns = function(_: string, statKey: string): {SearchPattern}
    return {
        {pattern = "рейтинг " .. conjugatedShortStats[statKey] .. " на (%d+)", location = "AfterValue"},
        {pattern = "рейтингу " .. conjugatedShortStats[statKey] .. " на (%d+)", location = "AfterValue"},
        {pattern = "рейтинга " .. conjugatedShortStats[statKey] .. " на (%d+)", location = "AfterValue"},
        {pattern = "рейтинг " .. conjugatedShortStats[statKey] .. " (%d+) на", location = "AfterValue"},
        {pattern = "рейтингу " .. conjugatedShortStats[statKey] .. " (%d+) на", location = "AfterValue"},
        {pattern = "рейтинга " .. conjugatedShortStats[statKey] .. " (%d+) на", location = "AfterValue"},
    };
end

-- These are used for the config frame under Interface -> Addons -> Little Buster.
ruRU.ConfigStrings ={
    DefensesHeader = "Защитные рейтинги",
    DefenseRatingCheckbox = "Конвертировать рейтинг защиты",
    DodgeRatingCheckbox = "Конвертировать рейтинг уклонения",
    ParryRatingCheckbox = "Конвертировать рейтинг парирования",
    BlockRatingCheckbox = "Конвертировать рейтинг блока щитом",

    SpellsHeader = "Рейтинги заклинаний",
    SpellHitRatingCheckbox = "Конвертировать рейтинг меткости",
    SpellCritRatingCheckbox = "Конвертировать рейтинг критического попадания",
    SpellHasteRatingCheckbox = "Конвертировать рейтинг скорости",

    PhysicalsHeader = "Рейтинги ближнего и дальнего боя",
    PhysicalHitRatingCheckbox = "Конвертировать рейтинг меткости",
    PhysicalCritRatingCheckbx = "Конвертировать рейтинг критического попадания",
    PhysicalHasteRatingCheckbox = "Конвертировать рейтинг скорости",
    PhysicalExpertiseRatingCheckbox = "Конвертировать рейтинг мастерства",

    AttributesHeader = "Характеристики",
    AgilityCheckbox = "Конвертировать ловкость",
    AgiDodgeCheck = "бонус к уклонению",
    AgiCritCheck = "бонус к критическому попаданию",
    AgiArmorCheck = "бонус к броне",
    AgiAPCheck = "бонус к силе атаки (AP)",
    AgiRAPCheck = "бонус к силе атаки дальнего боя (RAP)",
    AgilityHealingCheckbox = "бонус к лечению (BH)",

    IntellectCheckbox = "Конвертировать интеллект",
    IntellectManaCheckbox = "бонус маны",
    IntellectSpellCritCheckbox = "бонус к критическому попаданию",
    IntellectSpellDamageCheckbox = "бонус к урону заклинаниями (SPD)",
    IntellectHealingCheckbox = "бонус к лечению (BH)",
    IntellectManaRegenCheckbox = "бонус к регенерации маны (MP5)",
    IntellectRangedAPCheckbox = "бонус к силе атаки дальнего боя (RAP)",
    IntellectArmorCheckbox = "бонус к броне",
};

-- These are used to localize text injected into tooltips (mostly used for breaking down things like Agility and Intellect).
ruRU.StatStrings = {
    Dodge = "уклон.",
    Crit = "крит.",
    AttackPower = "AP", -- use english well-established abbreviation for AttackPower
    RangedAttackPower = "RAP", -- and for RangedAttackPower
    Armor = "брони",

    Mana = "маны",
    SpellCrit = "крит.",
    SpellDamage = "SPD",
    Healing = "BH",
    ManaRegen = "MP5",
}

LB.LocaleTables["ruRU"] = {};
LB.LocaleTables["ruRU"].getLocaleTable = function(): LocaleTable
    return ruRU;
end
