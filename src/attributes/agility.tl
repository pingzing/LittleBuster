local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];
local _locale = LB.GetLocaleTable(GetLocale());

local GetStatMod = LB.Attributes.Core.GetStatMod;
local GetBaseDodge = LB.Attributes.Core.GetBaseDodge;

-- Many of the calculations in here courtesy of StatLogic, and Whitetooth@Cenarius(US).

local function getDodgeFromAgi(agi: number): number
	-- First determine how much Agility contributes to the player's total dodge:
	local playerClass = ({UnitClass("player")} as {string, ClassEnum, number})[2];
	local playerRace = ({UnitRace("player")} as {string, RaceEnum, number})[2];
	
	local currentLevel = UnitLevel("player");
	local currentAgi = UnitStat("player", 2);
	local dodgeRating = GetCombatRating(CR_DODGE);
    local dodgeFromRating = LB.GetEffectFromRating(dodgeRating, CR_DODGE);

	local def = {UnitDefense("player")} as {number, number};
	local totalDefense = def[1] + def[2];

	local dodgeFromDefense = (totalDefense - currentLevel * 5) * .04;
	local dodgeFromAgi = GetDodgeChance() 
		- GetStatMod("ADD_DODGE", playerClass, playerRace) 
		- dodgeFromRating 
		- dodgeFromDefense;

	-- Then figure out how much dodge they're getting per point of agility
	local dodgePerAgi = (dodgeFromAgi - GetBaseDodge(playerClass)) / currentAgi;

	-- Then multiply
	return dodgePerAgi * agi;
end

function getBonusesString(value: number): string
	-- TODO: Check settings to see if the user wants to see dodge
	local dodgeFromAgi = getDodgeFromAgi(value);

	-- TODO: Combine all the stuff the user wanted, separate with commas (configurable?), stuff it all into a string

	return format("%.2f", dodgeFromAgi) .. "% " .. _locale.StatStrings.Dodge;
end

LB.Attributes.Agility.GetBonusesString = getBonusesString;