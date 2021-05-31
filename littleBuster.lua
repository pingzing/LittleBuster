local addonName, LB = ...;
local _strings = nil;

-- Checks to see if the given string of text contains the given stat
-- in its short form as given by _G[STAT_NAME_SHORT]. If it finds it,
-- it also parses out the rating, because we're almost certainly parsing
-- a trinket or some other weird free-form text.
--
-- `text`: The text to search for the given stat.
--
-- `statKey`: The key of the stat to search for.
--
-- Returns `startIndex`, `endIndex`, `rating`. On failure, returns `nil`.
local function statLineContainsShortPattern(text, statKey)
    local shortStatKey = LB.ShortStatKeys[statKey];
    if (shortStatKey == nil) then
        return nil;
    end

    local shortStatString = _G[shortStatKey]:lower();
    local shortStatPattern = shortStatString .. _strings.ShortStatPattern
    local discoveredRating = string.match(text, shortStatPattern);
    if (discoveredRating == nil) then
        return nil;
    end

    local startIndex, endIndex = string.find(text, shortStatPattern);
    if (startIndex == nil or endIndex == nil) then
        return nil;
    end

    return startIndex, endIndex, tonumber(discoveredRating);
end

-- `text`: The text to search.
-- 
-- `statKey`: The string key that we can use in _G[] to get the 
-- actual text of the stat as used in item tooltips.
-- 
-- Returns: `startIndex`, `endIndex`, `[ratingValue]`
local function statLineContains(text, statKey)
    local startIndex = nil;
    local endIndex = nil;
    local rating = nil;

    local strippedText = LB.strStripColors(text); -- Use stripped text for comparison, otherwise the first 11 chars are just color code stuff 

    local startsWithOnEquip = LB.strStartsWith(strippedText, ITEM_SPELL_TRIGGER_ONEQUIP);
    local startsWithPlus = LB.strStartsWith(strippedText, "+");

    -- These first three segments handle formatting like:
    --   Equip: Increases your dodge rating by 38
    --   +5 Block rating
    if (startsWithOnEquip or startsWithPlus) then
        -- First, try the long form
        local toFind = string.sub(_G[statKey], 1, -5);
        startIndex, endIndex = string.find(text, toFind);
        if (startIndex and endIndex) then
            return startIndex, endIndex;
        end

        -- If that didn't work, try the short form
        local shortStatKey = LB.ShortStatKeys[statKey];
        if (shortStatKey ~= nil) then -- some statKeys don't HAVE a corresponding shortStatKey        
            local toFind = string.sub(_G[shortStatKey], 1)
            startIndex, endIndex = string.find(text, toFind);
            if (startIndex and endIndex) then
                return startIndex, endIndex;
            end
        end

        -- If that didn't work, try the alternative phrasings 
        for _, alternative in ipairs(_strings.StatKeyAlternatives[statKey]) do
            startIndex, endIndex = string.find(text, alternative);
            if (startIndex and endIndex) then
                return startIndex, endIndex;
            end
        end
    end

    -- This block handles more free-form formatting like:
    --  Use: Increase your dodge rating by 300 for 10 sec.
    --  Equip: Your attacks have a chance ot increase your haste rating by 325 for 10 sec.
    startIndex, endIndex, rating = statLineContainsShortPattern(text, statKey);
    if (startIndex and endIndex and rating) then
        return startIndex, endIndex, rating;
    end

    return false;
end

local function injectStats(tooltip)
    local _, itemLink = tooltip:GetItem();
    if (not itemLink) then
        -- If we don't get an itemLink, don't even bother trying
        return;
    end

    local itemStats = {};
    GetItemStats(itemLink, itemStats);

    local linesModified = {};
    -- Skip the first line, as it's always an item name  
    for i = 2, tooltip:NumLines() do
        local lineRef = _G[tooltip:GetName() .. "TextLeft" .. i];
        local text = lineRef:GetText();
        if (text) then
            for _, statKey in pairs(LB.StatsKeys) do
                if (not linesModified[i]) then -- Skip the line if we've already modified it.
                    local statValue = nil;
                    -- statRating as set here doesn't necessarily correspond to this tooltip line. We'll verify when we call statLineContains()
                    local statRating = itemStats[statKey];
                    if (statRating) then
                        statValue = LB.GetEffectFromRating(statRating + 1, -- +1 because GetItemStats lies by -1
                        LB.ModToRating[statKey]);
                    end

                    local startIndex, endIndex, foundRating = statLineContains(text, statKey);
                    if (foundRating) then
                        statValue = LB.GetEffectFromRating(foundRating, LB.ModToRating[statKey]); -- no +1 here because we parsed it out of the tooltip text
                    end

                    if (startIndex and endIndex and statValue) then
                        local endFragment = LB.ContainsPercent[statKey] and "%" or "";
                        lineRef:SetText(text .. " (" .. format("%.2F", statValue) .. endFragment .. ")");
                        linesModified[i] = true;
                    end

                end
            end
        end
    end
end

if GetLocale() == "enUS" then
    _strings = LB.enUS.Strings;
else -- If we don't support this locale, fall back to enUS
    _strings = LB.enUS.Strings;
end

-- Entry point:
-- Note that this seems to fire continuously when hovering over an item in the paper doll
-- But, if we try to only fire one update per-frame, it seems to break shift-to-compare.
-- ...eh, good enough.
GameTooltip:HookScript("OnTooltipSetItem", injectStats);
ItemRefTooltip:HookScript("OnTooltipSetItem", injectStats);
ShoppingTooltip1:HookScript("OnTooltipSetItem", injectStats);
ShoppingTooltip2:HookScript("OnTooltipSetItem", injectStats);
