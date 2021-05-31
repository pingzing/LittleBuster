local addonName, LB = ...;

LB.StatsKeys = {
    meleeHitKey = "ITEM_MOD_HIT_MELEE_RATING",
    rangedHitKey = "ITEM_MOD_HIT_RANGED_RATING",
    meleeCritKey = "ITEM_MOD_CRIT_MELEE_RATING",
    rangedCritKey = "ITEM_MOD_CRIT_RANGED_RATING",
    expertiseKey = "ITEM_MOD_EXPERTISE_RATING",
    spellHitKey = "ITEM_MOD_HIT_SPELL_RATING",
    spellCritKey = "ITEM_MOD_CRIT_SPELL_RATING",
    spellHasteKey = "ITEM_MOD_HASTE_SPELL_RATING",
    hitKey = "ITEM_MOD_HIT_RATING",
    critKey = "ITEM_MOD_CRIT_RATING",
    hasteKey = "ITEM_MOD_HASTE_RATING",
    defenseKey = "ITEM_MOD_DEFENSE_SKILL_RATING",
    blockKey = "ITEM_MOD_BLOCK_RATING",
    dodgeKey = "ITEM_MOD_DODGE_RATING",
    parryKey = "ITEM_MOD_PARRY_RATING",
};

LB.ShortStatKeys = {
    [LB.StatsKeys.hitKey] = "ITEM_MOD_HIT_RATING_SHORT",
    [LB.StatsKeys.meleeHitKey] = "ITEM_MOD_HIT_MELEE_RATING_SHORT",
    [LB.StatsKeys.rangedHitKey] = "ITEM_MOD_HIT_RANGED_RATING_SHORT",
    [LB.StatsKeys.critKey] = "ITEM_MOD_CRIT_RATING_SHORT",
    [LB.StatsKeys.meleeCritKey] = "ITEM_MOD_CRIT_MELEE_RATING_SHORT",
    [LB.StatsKeys.rangedCritKey] = "ITEM_MOD_CRIT_RANGED_RATING_SHORT",
    [LB.StatsKeys.hasteKey] = "ITEM_MOD_HASTE_RATING_SHORT",
    [LB.StatsKeys.expertiseKey] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    [LB.StatsKeys.spellHitKey] = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    [LB.StatsKeys.spellCritKey] = "ITEM_MOD_CRIT_SPELL_RATING_SHORT",
    --    [LB.StatsKeys.spellHasteKey] = "ITEM_MOD_HASTE_SPELL_RATING_SHORT", -- This doesn't seem to exist, actually
    [LB.StatsKeys.defenseKey] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    [LB.StatsKeys.blockKey] = "ITEM_MOD_BLOCK_RATING_SHORT",
    [LB.StatsKeys.dodgeKey] = "ITEM_MOD_DODGE_RATING_SHORT",
    [LB.StatsKeys.parryKey] = "ITEM_MOD_PARRY_RATING_SHORT",
};

LB.ModToRating = {
    ["ITEM_MOD_HIT_RATING"] = CR_HIT_MELEE,
    ["ITEM_MOD_HIT_MELEE_RATING"] = CR_HIT_MELEE,
    ["ITEM_MOD_HIT_RANGED_RATING"] = CR_HIT_RANGED,
    ["ITEM_MOD_CRIT_RATING"] = CR_CRIT_MELEE,
    ["ITEM_MOD_CRIT_MELEE_RATING"] = CR_CRIT_MELEE,
    ["ITEM_MOD_CRIT_RANGED_RATING"] = CR_CRIT_RANGED,
    ["ITEM_MOD_HASTE_RATING"] = CR_HASTE_MELEE,
    ["ITEM_MOD_EXPERTISE_RATING"] = CR_EXPERTISE,
    ["ITEM_MOD_HIT_SPELL_RATING"] = CR_HIT_SPELL,
    ["ITEM_MOD_CRIT_SPELL_RATING"] = CR_CRIT_SPELL,
    ["ITEM_MOD_HASTE_SPELL_RATING"] = CR_HASTE_SPELL,
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = CR_DEFENSE_SKILL,
    ["ITEM_MOD_BLOCK_RATING"] = CR_BLOCK,
    ["ITEM_MOD_DODGE_RATING"] = CR_DODGE,
    ["ITEM_MOD_PARRY_RATING"] = CR_PARRY,
};

LB.ContainsPercent = {
    ["ITEM_MOD_HIT_RATING"] = true,
    ["ITEM_MOD_HIT_MELEE_RATING"] = true,
    ["ITEM_MOD_HIT_RANGED_RATING"] = true,
    ["ITEM_MOD_CRIT_RATING"] = true,
    ["ITEM_MOD_CRIT_MELEE_RATING"] = true,
    ["ITEM_MOD_CRIT_RANGED_RATING"] = true,
    ["ITEM_MOD_HASTE_RATING"] = true,
    ["ITEM_MOD_EXPERTISE_RATING"] = false,
    ["ITEM_MOD_HIT_SPELL_RATING"] = true,
    ["ITEM_MOD_CRIT_SPELL_RATING"] = true,
    ["ITEM_MOD_HASTE_SPELL_RATING"] = true,
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = false,
    ["ITEM_MOD_BLOCK_RATING"] = true,
    ["ITEM_MOD_DODGE_RATING"] = true,
    ["ITEM_MOD_PARRY_RATING"] = true,
}
