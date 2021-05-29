local addonName, LBGlobal = ...;

local _statsKeys = {
    hitKey = "ITEM_MOD_HIT_RATING",
    meleeHitKey = "ITEM_MOD_HIT_MELEE_RATING",
    rangedHitKey = "ITEM_MOD_HIT_RANGED_RATING",
    critKey = "ITEM_MOD_CRIT_RATING",
    meleeCritKey = "ITEM_MOD_CRIT_MELEE_RATING",
    rangedCritKey = "ITEM_MOD_CRIT_RANGED_RATING",
    hasteKey = "ITEM_MOD_HASTE_RATING",
    expertiseKey = "ITEM_MOD_EXPERTISE_RATING",
    spellHitKey = "ITEM_MOD_HIT_SPELL_RATING",
    spellCritKey = "ITEM_MOD_CRIT_SPELL_RATING",
    spellHasteKey = "ITEM_MOD_HASTE_SPELL_RATING",
    defenseKey = "ITEM_MOD_DEFENSE_SKILL_RATING",
    blockKey = "ITEM_MOD_BLOCK_RATING",
    dodgeKey = "ITEM_MOD_DODGE_RATING",
    parryKey = "ITEM_MOD_PARRY_RATING"
};

-- Blizzard is silly, and doesn't always use the strings pointed to by the 
-- various X_MOD_STAT_NAME, especially in older gear. So, we have here a table of alternative things
-- to try for each stat
local _statKeyAlternatives = {
    ["ITEM_MOD_HIT_RATING"] = {"Increases your hit rating by"},
    ["ITEM_MOD_HIT_MELEE_RATING"] = {"Increases your hit rating by"},
    ["ITEM_MOD_HIT_RANGED_RATING"] = {"Increases your hit rating by"},
    ["ITEM_MOD_CRIT_RATING"] = {"Increases your critical strike rating by"},
    ["ITEM_MOD_CRIT_MELEE_RATING"] = {
        "Increases your critical strike rating by"
    },
    ["ITEM_MOD_CRIT_RANGED_RATING"] = {
        "Increases your critical strike rating by"
    },
    ["ITEM_MOD_HASTE_RATING"] = {"Increases your haste rating by"},
    ["ITEM_MOD_EXPERTISE_RATING"] = {"Increases expertise rating by"},
    ["ITEM_MOD_HIT_SPELL_RATING"] = {"Increases your spell hit rating by"},
    ["ITEM_MOD_CRIT_SPELL_RATING"] = {
        "Increases your spell critical strike rating by"
    },
    ["ITEM_MOD_HASTE_SPELL_RATING"] = {},
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = {"Increases defense rating by"},
    ["ITEM_MOD_BLOCK_RATING"] = {"Increases your  block rating by"},
    ["ITEM_MOD_DODGE_RATING"] = {},
    ["ITEM_MOD_PARRY_RATING"] = {}
}

local _modToRating = {
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
    ["ITEM_MOD_PARRY_RATING"] = CR_PARRY
};

local _containsPercent = {
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
    ["ITEM_MOD_PARRY_RATING"] = true
}

-- Level 60 rating base
local _ratingBase = {
    [CR_DEFENSE_SKILL] = 1.5,
    [CR_DODGE] = 13.8,
    [CR_PARRY] = 13.8,
    [CR_BLOCK] = 6.9,
    [CR_HIT_MELEE] = 9.37931,
    [CR_HIT_RANGED] = 9.37931,
    [CR_HIT_SPELL] = 8,
    [CR_CRIT_MELEE] = 14,
    [CR_CRIT_RANGED] = 14,
    [CR_CRIT_SPELL] = 14,
    [CR_HASTE_MELEE] = 10, -- changed in 2.2
    [CR_HASTE_RANGED] = 10, -- changed in 2.2
    [CR_HASTE_SPELL] = 10, -- changed in 2.2  
    [CR_EXPERTISE] = 2.34483
}

local _level34Ratings = {
    [CR_DEFENSE_SKILL] = true,
    [CR_DODGE] = true,
    [CR_PARRY] = true,
    [CR_BLOCK] = true
}

local _ratingNameToID = {
    [CR_DEFENSE_SKILL] = "DEFENSE_RATING",
    [CR_DODGE] = "DODGE_RATING",
    [CR_PARRY] = "PARRY_RATING",
    [CR_BLOCK] = "BLOCK_RATING",
    [CR_HIT_MELEE] = "MELEE_HIT_RATING",
    [CR_HIT_RANGED] = "RANGED_HIT_RATING",
    [CR_HIT_SPELL] = "SPELL_HIT_RATING",
    [CR_CRIT_MELEE] = "MELEE_CRIT_RATING",
    [CR_CRIT_RANGED] = "RANGED_CRIT_RATING",
    [CR_CRIT_SPELL] = "SPELL_CRIT_RATING",
    [CR_HASTE_MELEE] = "MELEE_HASTE_RATING",
    [CR_HASTE_RANGED] = "RANGED_HASTE_RATING",
    [CR_HASTE_SPELL] = "SPELL_HASTE_RATING",
    [CR_EXPERTISE] = "EXPERTISE_RATING",
    ["DEFENSE_RATING"] = CR_DEFENSE_SKILL,
    ["DODGE_RATING"] = CR_DODGE,
    ["PARRY_RATING"] = CR_PARRY,
    ["BLOCK_RATING"] = CR_BLOCK,
    ["MELEE_HIT_RATING"] = CR_HIT_MELEE,
    ["RANGED_HIT_RATING"] = CR_HIT_RANGED,
    ["SPELL_HIT_RATING"] = CR_HIT_SPELL,
    ["MELEE_CRIT_RATING"] = CR_CRIT_MELEE,
    ["RANGED_CRIT_RATING"] = CR_CRIT_RANGED,
    ["SPELL_CRIT_RATING"] = CR_CRIT_SPELL,
    ["MELEE_HASTE_RATING"] = CR_HASTE_MELEE,
    ["RANGED_HASTE_RATING"] = CR_HASTE_RANGED,
    ["SPELL_HASTE_RATING"] = CR_HASTE_SPELL,
    ["EXPERTISE_RATING"] = CR_EXPERTISE
}

local function getEffectFromRating(rating, id)
    -- if id is stringID then convert to numberID
    if type(id) == "string" and _ratingNameToID[id] then
        id = _ratingNameToID[id];
    end
    -- check for invalid input
    if type(rating) ~= "number" or id < 1 or id > 26 then return 0 end
    local level = UnitLevel("player");
    -- 2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players
    --   will now convert these ratings into their corresponding defensive
    --   stats at the same rate as level 34 players.
    if level < 34 and _level34Ratings[id] then level = 34; end
    if level >= 60 then
        return rating / _ratingBase[id] / (82 / (262 - 3 * level));
    elseif level >= 10 then
        return rating / _ratingBase[id] / ((level - 8) / 52);
    else
        return rating / _ratingBase[id] / (2 / 52);
    end
end

-- returns true or false
local function statLineContains(text, statKey)
    -- First, try the actual official line
    local toFind = string.sub(_G[statKey], 1, -5);
    if string.find(text, toFind) then return true; end

    -- If that didn't work, get creative    
    for _, alternative in ipairs(_statKeyAlternatives[statKey]) do
        if string.find(text, alternative) then return true; end
    end

    return false;
end

local function injectStats(tooltip)
    local _, itemLink = tooltip:GetItem();
    if (not itemLink) then
        -- If we don't get an itemLink, don't even bother trying
        return;
    end

    local itemStats = GetItemStats(itemLink);

    -- TODO: Track which lines we've marked, so we don't double-mark things
    -- that the game says have both melee and ranged crit, for example
    for _, statKey in pairs(_statsKeys) do
        local statValue = nil;
        local statRating = itemStats[statKey];
        if (statRating) then
            statValue = getEffectFromRating(statRating + 1,
                                            _modToRating[statKey]);
        end
        -- Skip the first line, as it's always an item name  
        for i = 2, tooltip:NumLines() do
            local lineRef = _G[tooltip:GetName() .. "TextLeft" .. i];
            local text = lineRef:GetText();
            if text then
                if (statLineContains(text, statKey) and statRating) then
                    local endFragment = _containsPercent[statKey] and "%" or "";
                    lineRef:SetText(
                        text .. " (+" .. format("%.2F", statValue) ..
                            endFragment .. ")");
                end
            end
        end
    end

end

-- Hooks to make the addon function
-- Note that this seems to fire continuously, but also doesn't break shift-comparing.
-- So... eh. Good enough for now.
GameTooltip:HookScript("OnTooltipSetItem", injectStats);
ItemRefTooltip:HookScript("OnTooltipSetItem", injectStats);
ShoppingTooltip1:HookScript("OnTooltipSetItem", injectStats);
ShoppingTooltip2:HookScript("OnTooltipSetItem", injectStats);
