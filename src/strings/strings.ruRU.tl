local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local ruRU: LocaleTable = {};

ruRU.AlternativePatterns = {
    -- These patterns are tried first.
    ["ITEM_MOD_HIT_RATING"] = {
        "рейтинг меткости на (%d+)",
        "рейтинга меткости на (%d+)",
        "+(%d+) к рейтингу меткости"
    },
    ["ITEM_MOD_HIT_MELEE_RATING"] = {
        "рейтинг меткости на (%d+).",
    },
    ["ITEM_MOD_HIT_RANGED_RATING"] = {
        "рейтинг меткости на (%d+).",
    },
    ["ITEM_MOD_CRIT_RATING"] = {
        "рейтинг критического удара на (%d+).",
        "критического урона на (%d+) ед.",
        "+(%d+) к рейтингу критического удара", -- Seen on gems, mostly
    },
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        "рейтинг критического удара на (%d+).",
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        "рейтинг критического удара на (%d+).",
    },
    ["ITEM_MOD_HASTE_RATING"] = {
        "рейтинга скорости на (%d+) ед.",
        "рейтинг скорости боя на (%d+).",
    },
    ["ITEM_MOD_EXPERTISE_RATING"] = {
        "рейтинг мастерства на (%d+)."
    },
    ["ITEM_MOD_HIT_SPELL_RATING"] = {
        "меткость %(заклинания%) %+(%d+)", -- Because consistency is for the weak. JFC.
        "Повышение на (%d+)%% рейтинга меткости заклинаний.",
    },
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        "критический удар %(заклинания%) %+(%d+)", -- screwwww consistencyyyyyyy
        "повышает рейтинг критического эффекта заклинаний на (%d+)",
        "+(%d+) к рейтингу критического эффекта заклинаний",
        "+(%d+) к рейтингу критического удара заклинаниями", -- Seen on gems, mostly
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {
        "рейтинг скорости заклинаний на (%d+)",
        "рейтингу скорости заклинаний на (%d+)",
        "рейтинга скорости заклинаний на (%d+)",
        "рейтинг скорости заклинаний (%d+) на",
        "рейтингу скорости заклинаний (%d+) на",
        "рейтинга скорости заклинаний (%d+) на",
        "+(%d+) к рейтингу скорости заклинаний", -- gems
        "рейтинга скорости .+ (%d+ ед%.)", -- This one is really broad--we look for "рейтинга скорости (SOME NUMBER OF ANY CHARACTER) (some number of digits) ед."
    },
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {
        "повышает рейтинг защиты на (%d+).",
        "+(%d+) к рейтингу защиты",
    },
    ["ITEM_MOD_BLOCK_RATING"] = {
        "рейтинг блока на (%d+) ед.",
        "рейтинг блокирования щитом на (%d+)",
        "рейтинга блокирования щитом на (%d+)",
        "рейтингу блокирования щитом на (%d+)",
    },
    ["ITEM_MOD_DODGE_RATING"] = {
        "рейтинг уклонения (%d+ ед%.)",
        "рейтинга уклонения (%d+ ед%.)",
        "рейтингу уклонения (%d+ ед%.)",
        "+(%d+) к рейтингу уклонения",
    },
    ["ITEM_MOD_PARRY_RATING"] = {
        "+(%d+) к рейтингу парирования",
        "рейтинга парирования атак на (%d+) ед."
    },

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
}

-- These are tried second.
ruRU.GetShortStatPatterns = function(_: string, statKey: string): {string}
    return {
        "рейтинг " .. conjugatedShortStats[statKey] .. " на (%d+)",
        "рейтингу " .. conjugatedShortStats[statKey] .. " на (%d+)",
        "рейтинга " .. conjugatedShortStats[statKey] .. " на (%d+)",
        "рейтинг " .. conjugatedShortStats[statKey] .. " (%d+) на",
        "рейтингу " .. conjugatedShortStats[statKey] .. " (%d+) на",
        "рейтинга " .. conjugatedShortStats[statKey] .. " (%d+) на",
    };
end

ruRU.ConfigStrings ={

};

LB.LocaleTables["ruRU"] = {};
LB.LocaleTables["ruRU"].getLocaleTable = function(): LocaleTable
    return ruRU;
end
