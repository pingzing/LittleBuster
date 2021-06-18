local args = {...} as {string, SharedTable};
local LB = args[2];
local _locale = LB.GetLocaleTable(GetLocale());

local GetStatMod = LB.Attributes.Core.GetStatMod;
local GetBaseDodge = LB.Attributes.Core.GetBaseDodge;

-- Many of the calculations in here courtesy of StatLogic, and Whitetooth@Cenarius(US).

local function getDodgeFromAgi(agi: number): number
	local playerClass = UnitClass("player")[2];
	local playerRace = UnitRace("player")[2];
	
	local currentLevel = UnitLevel("player");
	local dodgeRating = GetCombatRating(CR_DODGE);
    local dodgeFromRating = LB.GetEffectFromRating(dodgeRating, CR_DODGE);

	local def: {number, number} = UnitDefense("player");
	local totalDefense = def[1] + def[2];

	local dodgeFromDefense = (totalDefense - currentLevel * 5) * .04;
	local dodgePerAgi = GetDodgeChance() - GetStatMod("ADD_DODGE", playerClass, playerRace) - dodgeFromRating - dodgeFromDefense;
	return (dodgePerAgi - GetBaseDodge(playerClass)) / agi
end

function getBonusesString(value: number): string
	-- TODO: Check settings to see if the user wants to see dodge
	local dodgeFromAgi = getDodgeFromAgi(value);

	-- TODO: Combine all the stuff the user wanted, separate with commas (configurable?), stuff it all into a string

	return tostring(dodgeFromAgi .. "%" .. _locale.StatStrings.Dodge);
end

LB.Attributes.Agility.GetBonusesString = getBonusesString;