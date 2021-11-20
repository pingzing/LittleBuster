local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];
local _config: {ConfigToggle: boolean} = nil;
local _locale = LB.GetLocaleTable(GetLocale());

local LoadConfig = LB.Attributes.Core.LoadConfig;
local GetStatMod = LB.Attributes.Core.GetStatMod;
local floor = math.floor;
local BlizzRound = LB.BlizzRound;

local _apPerStr: {ClassEnum:number} = {
    ["WARRIOR"] = 2,
    ["PALADIN"] = 2,
    ["HUNTER"] = 1,
    ["ROGUE"] = 1,
    ["PRIEST"] = 1,
    ["SHAMAN"] = 2,
    ["MAGE"] = 1,
    ["WARLOCK"] = 1,
    ["DRUID"] = 2,
};

local _bvPerStr: {ClassEnum:number} = {
    ["WARRIOR"] = 0.05,
    ["PALADIN"] = 0.05,
    ["HUNTER"] = 0,
    ["ROGUE"] = 0,
    ["PRIEST"] = 0,
    ["SHAMAN"] = 0.05,
    ["MAGE"] = 0,
    ["WARLOCK"] = 0,
    ["DRUID"] = 0,
}

local function getAPFromStr(strength: number, class: ClassEnum): number
    local apPerStr = _apPerStr[class];
    return strength * apPerStr; -- TODO: Is this value affected by +% AP modifiers? (probably not)
end

local function getBlockValueFromStr(strength: number, class: ClassEnum): number
    local bvPerStr = _bvPerStr[class];
    -- TODO: Is this value affected by +BV % talents?
    return strength * bvPerStr; -- TODO: This may be BlizzRound'ed, instead of just "chop the decimals off" rounded.
end

local function getBonusesString(strength: number): string
    local config = LoadConfig();
    if (not config) then
        return nil;
    end

    if (not config["Strength-AttackPower"]
        and not config["Strength-BlockValue"]) then
            return nil;
    end

    local statStrings: {string} = {};

    local playerClass = ({UnitClass("player")} as {string, ClassEnum, number})[2];
    local playerRace = ({UnitRace("player")} as {string, RaceEnum, number})[2];

    local modifiedStr = strength * GetStatMod("MOD_STR", playerClass, playerRace);
    modifiedStr = BlizzRound(modifiedStr);

    -- AP
    if (config["Strength-AttackPower"]) then
        local apFromStr = getAPFromStr(strength, playerClass);
        if (apFromStr > 0) then
            local apString = format("%d", apFromStr) .. " " .. _locale.StatStrings.AttackPower;
            table.insert(statStrings, apString);
        end
    end

    -- Block Value
    if (config["Strength-BlockValue"]) then
        local bvFromStr = getBlockValueFromStr(strength, playerClass);
        if (bvFromStr > 0) then
            local bvString = format("%.1F", bvFromStr) .. " " .. _locale.StatStrings.BlockValue;
            table.insert(statStrings, bvString);
        end
    end

    return table.concat(statStrings, ", ");
end

LB.Attributes.Strength.GetBonusesString = getBonusesString;