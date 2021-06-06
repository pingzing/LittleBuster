local args = { ... };
local LB = args[2];
local G = getfenv(0);
local _locale = nil;
local _goldColor = "|cfffffe8b";
local _colorEnd = "|r";



local StatKeys = LB.StatKeys;
local ShortStatKeys = LB.ShortStatKeys;
local ModToRating = LB.ModToRating;
local ContainsPercent = LB.ContainsPercent;


local GetEffectFromRating = LB.GetEffectFromRating;


local GetLocaleTable = LB.GetLocaleTable;

local TooltipType = {}






local TooltipState = {}





local LineModInfo = {}







local LineData = {}




local _tooltipState = {
   ["GameTooltip"] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
   ["ItemRefTooltip"] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
   ["ShoppingTooltip1"] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
   ["ShoppingTooltip2"] = { itemID = nil, modifiedLines = {}, timesSeen = 0 },
}

local function getItemIDFromLink(itemLink)

   local firstColonIndex = string.find(itemLink, ":");
   local secondColonIndex = string.find(itemLink, ":", firstColonIndex + 1);
   local itemID = string.sub(itemLink, firstColonIndex + 1, secondColonIndex - 1);
   return tonumber(itemID)
end













local function scanForStat(text, statKey, _)
   local lowercaseText = text:lower();
   local discoveredCapture = nil;
   local successfulPattern = nil;


   for _, pattern in ipairs(_locale.Strings.AlternativePatterns[statKey]) do
      discoveredCapture = string.match(lowercaseText, pattern:lower());
      if (discoveredCapture ~= nil) then
         successfulPattern = pattern;
         break
      end
   end


   if (discoveredCapture == nil) then
      local shortStatKey = ShortStatKeys[statKey];
      if (shortStatKey == nil) then
         return { nil, nil, nil }
      end

      local shortStatString = (G[shortStatKey]):lower();
      local shortStatPatterns = _locale.GetShortStatPatterns(shortStatString, statKey);
      for _, pattern in ipairs(shortStatPatterns) do
         discoveredCapture = string.match(lowercaseText, pattern);
         if (discoveredCapture ~= nil) then
            successfulPattern = pattern;
            break
         end
      end
   end

   if (discoveredCapture == nil) then
      return { nil, nil, nil }
   end

   successfulPattern = successfulPattern:lower();
   local patternStart, patternEnd = string.find(lowercaseText, successfulPattern);
   if (patternStart == nil or patternEnd == nil) then
      return { nil, nil, nil }
   end


   local value = tonumber(string.match(discoveredCapture, "(%d+)"));
   if (patternStart and patternEnd and value) then

      local patternSubstring = lowercaseText:sub(patternStart, patternEnd);
      local captureStart, captureEnd = string.find(patternSubstring, discoveredCapture);

      return { captureStart + patternStart, captureEnd + patternStart, value }
   end

   return { nil, nil, nil }
end



local function modifyLines(statsFound)
   local modifiedLines = {};
   for lineNum, lineData in pairs(statsFound) do


      local indexOffset = 0;
      local currentLine = lineData.originalText;

      table.sort(lineData.modifications, function(modA, modB)
         return modA.startIndex < modB.startIndex
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

   return modifiedLines
end



local function tryGenerateModifiedLine(text, statKey, indicesProcessed)
   local statValue = nil;


   local found = scanForStat(text, statKey.key, statKey.type);
   local valueStart = found[1];
   local valueEnd = found[2];
   local foundValue = found[3];
   if (not (indicesProcessed[valueStart])) then
      if (foundValue) then
         if (statKey.type == "Rating") then
            statValue = GetEffectFromRating(foundValue, ModToRating[statKey.key]);
         end

      end

      if (valueStart and valueEnd and statValue) then
         local currentColorCode = (select(3, string.find(text, "(|c%x%x%x%x%x%x%x%x)")) or _colorEnd);
         local endFragment = ContainsPercent[statKey.key] and "%" or "";
         local formattedValue = _goldColor .. " (" .. format("%.2F", statValue) .. endFragment ..
         ")" .. currentColorCode;
         return { valueStart, valueEnd, formattedValue }
      end
   end

   return { nil, nil, nil }
end

local function generateModifiedTooltipLines(tooltip)
   local statsFound = {};

   for i = 2, tooltip:NumLines() do
      local lineRef = G[tooltip:GetName() .. "TextLeft" .. i];
      local text = lineRef:GetText();
      local indicesProcessed = {};
      if (text) then
         for _, statKey in ipairs(StatKeys) do
            local modifiedLineInfo = 
            tryGenerateModifiedLine(text, statKey, indicesProcessed);
            local valueStart = modifiedLineInfo[1];
            local valueEnd = modifiedLineInfo[2];
            local formattedValue = modifiedLineInfo[3];
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

               indicesProcessed[valueStart] = true;
            end
         end
      end
   end

   return modifyLines(statsFound)
end

local function injectModifiedLines(tooltip, modifiedLines)

   if (next(modifiedLines) == nil) then
      return
   end
   for i = 2, tooltip:NumLines() do
      local modifiedText = modifiedLines[i]
      if (modifiedText) then
         local lineRef = (G[tooltip:GetName() .. "TextLeft" .. i]);
         lineRef:SetText(modifiedText);
      end
   end
end

local function injectStats(tooltip, tooltipType)
   local item = { tooltip:GetItem() };
   if (not item) then

      return
   end

   local itemID = getItemIDFromLink(item[2]);
   local tooltipState = _tooltipState[tooltipType];





   if (tooltipState.itemID == itemID and tooltipState.timesSeen > 1) then
      tooltipState.timesSeen = tooltipState.timesSeen + 1;
      injectModifiedLines(tooltip, tooltipState.modifiedLines);
      return
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


_locale = GetLocaleTable(GetLocale());

GameTooltip:HookScript("OnTooltipSetItem", function(self)
   injectStats(self, "GameTooltip");
end);
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
   injectStats(self, "ItemRefTooltip");
end);
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
   injectStats(self, "ShoppingTooltip1");
end);
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self)
   injectStats(self, "ShoppingTooltip2");
end);
