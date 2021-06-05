local addonName, LB = ...;
local _locale = nil;

local _tooltipType = {
    GameTooltip = "GameTooltip",
    ItemRefTooltp = "ItemRefTooltip",
    ShoppingTooltip1 = "ShoppingTooltip1",
    ShoppingTooltip2 = "ShoppingTooltip2",
};

local _tooltipState = {
    [_tooltipType.GameTooltip] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [_tooltipType.ItemRefTooltp] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [_tooltipType.ShoppingTooltip1] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [_tooltipType.ShoppingTooltip2] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
};

local function getItemIDFromLink(itemLink)
    -- |cff9d9d9d|Hitem:0000000: <-- the zeroes are the item ID.
    local firstColonIndex = string.find(itemLink, ":");
    local secondColonIndex = string.find(itemLink, ":", firstColonIndex + 1);
    local itemID = string.sub(itemLink, firstColonIndex + 1, secondColonIndex - 1);
    return tonumber(itemID);
end

local function findRatingIndices(text, patternStartIndex, patternEndIndex)
    local substring = strsub(text, patternStartIndex, patternEndIndex);
    return string.find(substring, "(%d+)");
end

-- Checks to see if the given string of text contains the given stat.
-- If it finds it, it returns the start and end index of the numeric
-- rating value, as well as the rating value itself.
-- 
-- `text`: The text to search for the given stat.
--
-- `statKey`: The key of the stat to search for.
--
-- Returns `startIndex`, `endIndex`, `rating`. On failure, returns `nil`, `nil`, `nil`.
local function scanTooltipLine(text, statKey)
    local lowercaseText = text:lower();
    local discoveredRating = nil;
    local foundPattern = nil;

    -- First, try the alternatives we've noted to deal with weird cases where Blizzard-defined keys don't work
    for _, pattern in pairs(_locale.Strings.StatKeyAlternatives[statKey]) do
        discoveredRating = string.match(lowercaseText, pattern);
        if (discoveredRating ~= nil) then
            foundPattern = pattern;
            break
        end
    end

    -- If that didn't work, try the short stat phrases that use the Blizzard _SHORT key as a building block.
    if (discoveredRating == nil) then
        local shortStatKey = LB.ShortStatKeys[statKey];
        if (shortStatKey == nil) then
            return nil;
        end

        local shortStatString = _G[shortStatKey]:lower();
        local shortStatPatterns = _locale.GetShortStatPatterns(shortStatString);
        for _, pattern in pairs(shortStatPatterns) do
            discoveredRating = string.match(lowercaseText, pattern);
            if (discoveredRating ~= nil) then
                foundPattern = pattern;
                break
            end
        end
    end

    if (discoveredRating == nil) then
        return nil;
    end

    local startIndex, endIndex = string.find(lowercaseText, foundPattern);
    if (startIndex == nil or endIndex == nil) then
        return nil;
    end

    local rating = tonumber(discoveredRating);
    if (startIndex and endIndex and rating) then
        -- Get the indices of the actual rating value, so we know exactly where to insert our stat value.
        local ratingStartIndex, ratingEndIndex = findRatingIndices(lowercaseText, startIndex,
                                                                   endIndex);
        return ratingStartIndex + startIndex, ratingEndIndex + startIndex, rating;
    end

    return nil, nil, nil;
end

local function generateModifiedTooltipLines(tooltip)
    local linesModified = {};
    -- Skip the first line, as it's always an item name  
    for i = 2, tooltip:NumLines() do
        local lineRef = _G[tooltip:GetName() .. "TextLeft" .. i];
        local text = lineRef:GetText();
        if (text) then
            for _, statKey in ipairs(LB.StatsKeys) do
                if (not linesModified[i]) then -- Skip the line if we've already modified it.
                    local statValue = nil;

                    -- Parse the stat rating and its location out of the tooltip line.
                    local ratingStart, ratingEnd, foundRating = scanTooltipLine(text, statKey);
                    if (foundRating) then
                        statValue = LB.GetEffectFromRating(foundRating, LB.ModToRating[statKey]);
                    end

                    if (ratingStart and ratingEnd and statValue) then
                        -- TODO: Different color codes for the formatted value
                        local endFragment = LB.ContainsPercent[statKey] and "%" or "";
                        local formattedValue = " (" .. format("%.2F", statValue) .. endFragment ..
                                                   ")";
                        local modifiedText = text:sub(1, ratingEnd - 1) .. formattedValue ..
                                                 text:sub(ratingEnd);
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

    -- If this particular tooltip already knows the lines for this item, just reuse what we have and return early
    -- Don't use the cached value unless we've seen the item at least TWICE though.
    -- Why? The first tooltip retrieval per GAME BOOT, (not /console reloadui session!)
    -- only seems to get base stats, not on-equip bonuses or other data.
    if (tooltipState.itemID == itemID and tooltipState.timesSeen > 1) then
        tooltipState.timesSeen = tooltipState.timesSeen + 1;
        injectModifiedLines(tooltip, tooltipState.modifiedLines);
        return;
    end

    local linesModified = generateModifiedTooltipLines(tooltip);

    if (tooltipState.itemID == itemID) then
        tooltipState.timesSeen = tooltipState.timesSeen + 1;
    else
        tooltipState.timesSeen = 0;
    end
    tooltipState.itemID = itemID;
    tooltipState.modifiedLines = linesModified;
    injectModifiedLines(tooltip, linesModified);
end

-- Entry point
_locale = LB.getLocaleTable(GetLocale());

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
