local addonName, LB = ...;
local _locale = nil;
local _goldColor = "|cfffffe8b"; -- r = 1.0, g = 0.996,  b = 0.545,
local _colorEnd = "|r";

-- Localize globals for sanity's sake:
-- mappings.lua
local StatKeys = LB.StatKeys;
local ShortStatKeys = LB.ShortStatKeys;
local ModToRating = LB.ModToRating;
local ContainsPercent = LB.ContainsPercent;
local StatTypeEnum = LB.StatTypeEnum;

-- statConversion.lua
local GetEffectFromRating = LB.GetEffectFromRating;

-- localeCore.lua
local GetLocaleTable = LB.GetLocaleTable;

local TooltipTypeEnum = {
    GameTooltip = "GameTooltip",
    ItemRefTooltp = "ItemRefTooltip",
    ShoppingTooltip1 = "ShoppingTooltip1",
    ShoppingTooltip2 = "ShoppingTooltip2",
};

local _tooltipState = {
    [TooltipTypeEnum.GameTooltip] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [TooltipTypeEnum.ItemRefTooltp] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [TooltipTypeEnum.ShoppingTooltip1] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
    [TooltipTypeEnum.ShoppingTooltip2] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
};

local function getItemIDFromLink(itemLink)
    -- |cff9d9d9d|Hitem:0000000: <-- the zeroes are the item ID.
    local firstColonIndex = string.find(itemLink, ":");
    local secondColonIndex = string.find(itemLink, ":", firstColonIndex + 1);
    local itemID = string.sub(itemLink, firstColonIndex + 1, secondColonIndex - 1);
    return tonumber(itemID);
end

-- Checks to see if the given string of text contains the given stat.
-- If it finds it, it returns the start and end index indices of the stat value
-- (where 'stat value' is defined by the patterns given in the localization files, and
-- may contain more than just a numeric value) as well as the stat value itself.
-- 
-- `text`: The text to search for the given stat.
--
-- `statKey`: The key of the stat to search for.
--
-- `statType`: The type of the stat, i.e. whether it's a rating or just a value.
--
-- Returns `startIndex`, `endIndex`, `value`. On failure, returns `nil`, `nil`, `nil`.
local function scanForStat(text, statKey, statType)
    local lowercaseText = text:lower();
    local discoveredCapture = nil; -- A capture will usually contain just a number, but not necessarily.
    local successfulPattern = nil;

    -- First, try the alternatives we've noted to deal with weird cases where Blizzard-defined keys don't work
    for _, pattern in pairs(_locale.Strings.AlternativePatterns[statKey]) do
        discoveredCapture = string.match(lowercaseText, pattern:lower());
        if (discoveredCapture ~= nil) then
            successfulPattern = pattern;
            break
        end
    end

    -- If that didn't work, try the short stat phrases that use the Blizzard _SHORT key as a building block.
    if (discoveredCapture == nil) then
        local shortStatKey = ShortStatKeys[statKey];
        if (shortStatKey == nil) then
            return nil, nil, nil;
        end

        local shortStatString = _G[shortStatKey]:lower();
        local shortStatPatterns = _locale.GetShortStatPatterns(shortStatString, statKey);
        for _, pattern in pairs(shortStatPatterns) do
            discoveredCapture = string.match(lowercaseText, pattern);
            if (discoveredCapture ~= nil) then
                successfulPattern = pattern;
                break
            end
        end
    end

    if (discoveredCapture == nil) then
        return nil, nil, nil;
    end

    successfulPattern = successfulPattern:lower();
    local patternStart, patternEnd = string.find(lowercaseText, successfulPattern);
    if (patternStart == nil or patternEnd == nil) then
        return nil, nil, nil;
    end

    -- In case the value we found contains more than just a number, isolate out the number,
    local value = tonumber(string.match(discoveredCapture, "(%d+)"));
    if (patternStart and patternEnd and value) then
        -- Search within substring of the tooltip we found our pattern in for the captured value
        local patternSubstring = lowercaseText:sub(patternStart, patternEnd);
        local captureStart, captureEnd = string.find(patternSubstring, discoveredCapture);
        -- And make sure to add in the diff between the length of the substring and original tooltip string
        return captureStart + patternStart, captureEnd + patternStart, value;
    end

    return nil, nil, nil;
end

-- Take all the conversion data we found in the tooltip, and use it generate
-- rewritten tooltip lines.
local function modifyLines(statsFound)
    local modifiedLines = {};
    for lineNum, lineData in pairs(statsFound) do
        -- Because we're mutating the line, all the indices will be off once we start changing it.
        -- Track how much we've changed it with this offset.
        local indexOffset = 0;
        local currentLine = lineData.originalText;
        -- Sort lineData.modifications so that we mutate stats in the order they appear        
        table.sort(lineData.modifications, function(modA, modB)
            return modA.startIndex < modB.startIndex;
        end)
        for _, statData in ipairs(lineData.modifications) do
            local prevLen = currentLine:len();
            currentLine = currentLine:sub(1, statData.endIndex - 1 + indexOffset) ..
                              statData.formattedString ..
                              currentLine:sub(statData.endIndex + indexOffset);
            local lenDiff = currentLine:len() - prevLen;
            indexOffset = indexOffset + lenDiff;
        end
        modifiedLines[lineNum] = currentLine;
    end

    return modifiedLines;
end

-- Take a tooltip's text and see if we can find the given stat. If we do,
-- we'll return its indices, and a formatted string the caller can insert wherever it likes.
local function tryGenerateModifiedLine(text, statKey, indicesProcessed)
    local statValue = nil;

    -- Parse the stat value and its location out of the tooltip line.
    local valueStart, valueEnd, foundValue = scanForStat(text, statKey.key, statKey.type);
    if (not (indicesProcessed[valueStart])) then
        if (foundValue) then
            if (statKey.type == StatTypeEnum.Rating) then
                statValue = GetEffectFromRating(foundValue, ModToRating[statKey.key]);
            end
            -- TODO: If it's a Value, do Value-y things. 
        end

        if (valueStart and valueEnd and statValue) then
            local currentColorCode = select(3, string.find(text, "(|c%x%x%x%x%x%x%x%x)")) or "|r";
            local endFragment = ContainsPercent[statKey.key] and "%" or "";
            local formattedValue = _goldColor .. " (" .. format("%.2F", statValue) .. endFragment ..
                                       ")" .. currentColorCode;
            return valueStart, valueEnd, formattedValue;
        end
    end

    return nil, nil, nil;
end

local function generateModifiedTooltipLines(tooltip)
    local statsFound = {};
    -- Skip the first line, as it's always an item name
    for i = 2, tooltip:NumLines() do
        local lineRef = _G[tooltip:GetName() .. "TextLeft" .. i];
        local text = lineRef:GetText();
        local indicesProcessed = {}; -- contains a mapping of valueStartIndex -> boolean, to track which values we've already looked at
        if (text) then
            for _, statKey in ipairs(StatKeys) do
                local valueStart, valueEnd, formattedValue =
                    tryGenerateModifiedLine(text, statKey, indicesProcessed);
                if (valueStart and valueEnd and formattedValue) then
                    local lineData = statsFound[i];
                    if (lineData == nil) then
                        lineData = { originalText = text, modifications = {} };
                        statsFound[i] = lineData;
                    end
                    table.insert(lineData.modifications, {
                        stat = statKey.key,
                        statType = statKey.type,
                        startIndex = valueStart,
                        endIndex = valueEnd,
                        formattedString = formattedValue,
                    });
                    -- Mark this stat's index as processed
                    indicesProcessed[valueStart] = true;
                end
            end
        end
    end

    return modifyLines(statsFound);
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
_locale = GetLocaleTable(GetLocale());

GameTooltip:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, TooltipTypeEnum.GameTooltip);
end);
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, TooltipTypeEnum.ItemRefTooltp);
end);
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, TooltipTypeEnum.ShoppingTooltip1);
end);
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self)
    injectStats(self, TooltipTypeEnum.ShoppingTooltip2);
end);

-- Debugging helpers

function Dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = "\"" .. k .. "\""
            end
            s = s .. "[" .. k .. "] = " .. Dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end
