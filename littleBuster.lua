local addonName, LB = ...;
local _locale = nil;

local _tooltipType = {
    GameTooltip = "GameTooltip",
    ItemRefTooltp = "ItemRefTooltip",
    ShoppingTooltip1 = "ShoppingTooltip1",
    ShoppingTooltip2 = "ShoppingTooltip2",
};

local _tooltipState = {
    [_tooltipType.GameTooltip] = { itemID = nil, modifiedLines = nil },
    [_tooltipType.ItemRefTooltp] = { itemID = nil, modifiedLines = nil },
    [_tooltipType.ShoppingTooltip1] = { itemID = nil, modifiedLines = nil },
    [_tooltipType.ShoppingTooltip2] = { itemID = nil, modifiedLines = nil },
};

local function getItemIDFromLink(itemLink)
    -- |cff9d9d9d|Hitem:0000000: <-- the zeroes are the item ID.
    local firstColonIndex = string.find(itemLink, ":");
    local secondColonIndex = string.find(itemLink, ":", firstColonIndex + 1);
    local itemID = string.sub(itemLink, firstColonIndex + 1, secondColonIndex - 1);
    return tonumber(itemID);
end

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

    local shortStatString = _G[shortStatKey];
    local shortStatPatterns = _locale.GetShortStatPatterns(shortStatString);
    local discoveredRating = nil;
    local successfulPattern = nil;
    for _, pattern in pairs(shortStatPatterns) do
        discoveredRating = string.match(text, pattern);
        if (discoveredRating ~= nil) then
            successfulPattern = pattern;
            break
        end
    end
    if (discoveredRating == nil) then
        return nil;
    end

    local startIndex, endIndex = string.find(text, successfulPattern);
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
        local toFind = string.gsub(_G[statKey], "%%s", "(%%d+)");
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
        for _, alternative in ipairs(_locale.Strings.StatKeyAlternatives[statKey]) do
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

local function generateModifiedTooltipLines(tooltip, itemStats)
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
                        statValue =
                            LB.GetEffectFromRating(statRating + 1, -- +1 because GetItemStats lies by -1
                                                   LB.ModToRating[statKey]);
                    end

                    local startIndex, endIndex, foundRating = statLineContains(text, statKey);
                    if (foundRating) then
                        statValue = LB.GetEffectFromRating(foundRating, LB.ModToRating[statKey]); -- no +1 here because we parsed it out of the tooltip text
                    end

                    if (startIndex and endIndex and statValue) then
                        local endFragment = LB.ContainsPercent[statKey] and "%" or "";
                        local modifiedText = text .. " (" .. format("%.2F", statValue) ..
                                                 endFragment .. ")";
                        linesModified[i] = modifiedText;
                    end
                end
            end
        end
    end
    return linesModified;
end

local function injectModifiedLines(tooltip, modifiedLines)
    -- If the table is empty, we can bail immediately.
    if (next(modifiedLines) == nil) then
        return;
    end
    for i = 2, tooltip:NumLines() do
        local modifiedText = modifiedLines[i]
        if (modifiedText) then
            local lineRef = _G[tooltip:GetName() .. "TextLeft" .. i];
            lineRef:SetText(modifiedText);
        end
    end
end

local function injectStats(tooltip, tooltipType)
    local _, itemLink = tooltip:GetItem();
    if (not itemLink) then
        -- If we don't get an itemLink, don't even bother trying
        return;
    end

    local itemID = getItemIDFromLink(itemLink);
    local tooltipState = _tooltipState[tooltipType];
    if (tooltipState.itemID == itemID and next(tooltipState.modifiedLines)) then
        injectModifiedLines(tooltip, tooltipState.modifiedLines);
        return;
    end

    local itemStats = {};
    GetItemStats(itemLink, itemStats);

    local linesModified = generateModifiedTooltipLines(tooltip, itemStats);

    tooltipState.itemID = itemID;
    tooltipState.modifiedLines = linesModified;
    injectModifiedLines(tooltip, linesModified);
end

local locale = GetLocale();
if locale == "enUS" then
    _locale = LB.enUS;
elseif locale == "esMX" then -- <-- this is reeeal experimental. Tooltips in other languages are TERRIBLE.
    _locale = LB.esMX;
else -- If we don't support this locale, fall back to enUS
    print("Little Buster is running in an unsupported locale (" .. locale ..
              "). Defaulting to enUS.");
    _locale = LB.enUS;
end

-- Entry point:
-- Note that this seems to fire continuously when hovering over an item in the paper doll
-- But, if we try to only fire one update per-frame, it seems to break shift-to-compare.
-- ...eh, good enough.
GameTooltip:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, _tooltipType.GameTooltip);
end);
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, _tooltipType.ItemRefTooltp);
end);
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, _tooltipType.ShoppingTooltip1);
end);
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, _tooltipType.ShoppingTooltip2);
end);
