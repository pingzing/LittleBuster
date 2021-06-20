local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];
local _config: {ConfigToggle: boolean} = nil;
local _locale = LB.GetLocaleTable(GetLocale());

local GetStatMod = LB.Attributes.Core.GetStatMod;
local GetBaseDodge = LB.Attributes.Core.GetBaseDodge;

local function loadConfig(): {ConfigToggle: boolean}
    if (_config) then
        return _config;
    else
        if (LB.Config) then
            _config = LB.Config.DisplayToggles;
            return _config;
        else 
            return nil; -- Addon isn't done loading yet, and Config isn't populated
        end
    end
end

-- Many of the calculations, tables, values, etc, in here courtesy of StatLogic, and Whitetooth@Cenarius(US).

local _critPerAgi: {number:{number:number}} = {
 -- Lvl   Warr     Pala    Hunt    Rog     Pri     Sham    Warl    Mage    Dru
    [1] = {0.2500, 0.2174, 0.2840, 0.4476, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
    [2] = {0.2381, 0.2070, 0.2834, 0.4290, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
    [3] = {0.2381, 0.2070, 0.2711, 0.4118, 0.0909, 0.1583, 0.0771, 0.1429, 0.1923, },
    [4] = {0.2273, 0.1976, 0.2530, 0.3813, 0.0865, 0.1583, 0.0735, 0.1429, 0.1923, },
    [5] = {0.2174, 0.1976, 0.2430, 0.3677, 0.0865, 0.1511, 0.0735, 0.1429, 0.1836, },
    [6] = {0.2083, 0.1890, 0.2337, 0.3550, 0.0865, 0.1511, 0.0735, 0.1364, 0.1836, },
    [7] = {0.2083, 0.1890, 0.2251, 0.3321, 0.0865, 0.1511, 0.0735, 0.1364, 0.1756, },
    [8] = {0.2000, 0.1812, 0.2171, 0.3217, 0.0826, 0.1446, 0.0735, 0.1364, 0.1756, },
    [9] = {0.1923, 0.1812, 0.2051, 0.3120, 0.0826, 0.1446, 0.0735, 0.1304, 0.1683, },
   [10] = {0.1923, 0.1739, 0.1984, 0.2941, 0.0826, 0.1385, 0.0701, 0.1304, 0.1553, },
   [11] = {0.1852, 0.1739, 0.1848, 0.2640, 0.0826, 0.1385, 0.0701, 0.1250, 0.1496, },
   [12] = {0.1786, 0.1672, 0.1670, 0.2394, 0.0790, 0.1330, 0.0701, 0.1250, 0.1496, },
   [13] = {0.1667, 0.1553, 0.1547, 0.2145, 0.0790, 0.1330, 0.0701, 0.1250, 0.1443, },
   [14] = {0.1613, 0.1553, 0.1441, 0.1980, 0.0790, 0.1279, 0.0701, 0.1200, 0.1443, },
   [15] = {0.1563, 0.1449, 0.1330, 0.1775, 0.0790, 0.1231, 0.0671, 0.1154, 0.1346, },
   [16] = {0.1515, 0.1449, 0.1267, 0.1660, 0.0757, 0.1188, 0.0671, 0.1111, 0.1346, },
   [17] = {0.1471, 0.1403, 0.1194, 0.1560, 0.0757, 0.1188, 0.0671, 0.1111, 0.1303, },
   [18] = {0.1389, 0.1318, 0.1117, 0.1450, 0.0757, 0.1147, 0.0671, 0.1111, 0.1262, },
   [19] = {0.1351, 0.1318, 0.1060, 0.1355, 0.0727, 0.1147, 0.0671, 0.1071, 0.1262, },
   [20] = {0.1282, 0.1242, 0.0998, 0.1271, 0.0727, 0.1073, 0.0643, 0.1034, 0.1122, },
   [21] = {0.1282, 0.1208, 0.0962, 0.1197, 0.0727, 0.1073, 0.0643, 0.1000, 0.1122, },
   [22] = {0.1250, 0.1208, 0.0910, 0.1144, 0.0727, 0.1039, 0.0643, 0.1000, 0.1092, },
   [23] = {0.1190, 0.1144, 0.0872, 0.1084, 0.0699, 0.1039, 0.0643, 0.0968, 0.1063, },
   [24] = {0.1163, 0.1115, 0.0829, 0.1040, 0.0699, 0.1008, 0.0617, 0.0968, 0.1063, },
   [25] = {0.1111, 0.1087, 0.0797, 0.0980, 0.0699, 0.0978, 0.0617, 0.0909, 0.1010, },
   [26] = {0.1087, 0.1060, 0.0767, 0.0936, 0.0673, 0.0950, 0.0617, 0.0909, 0.1010, },
   [27] = {0.1064, 0.1035, 0.0734, 0.0903, 0.0673, 0.0950, 0.0617, 0.0909, 0.0985, },
   [28] = {0.1020, 0.1011, 0.0709, 0.0865, 0.0673, 0.0924, 0.0617, 0.0882, 0.0962, },
   [29] = {0.1000, 0.0988, 0.0680, 0.0830, 0.0649, 0.0924, 0.0593, 0.0882, 0.0962, },
   [30] = {0.0962, 0.0945, 0.0654, 0.0792, 0.0649, 0.0875, 0.0593, 0.0833, 0.0878, },
   [31] = {0.0943, 0.0925, 0.0637, 0.0768, 0.0649, 0.0875, 0.0593, 0.0833, 0.0859, },
   [32] = {0.0926, 0.0925, 0.0614, 0.0741, 0.0627, 0.0853, 0.0593, 0.0811, 0.0859, },
   [33] = {0.0893, 0.0887, 0.0592, 0.0715, 0.0627, 0.0831, 0.0571, 0.0811, 0.0841, },
   [34] = {0.0877, 0.0870, 0.0575, 0.0691, 0.0627, 0.0831, 0.0571, 0.0789, 0.0824, },
   [35] = {0.0847, 0.0836, 0.0556, 0.0664, 0.0606, 0.0792, 0.0571, 0.0769, 0.0808, },
   [36] = {0.0833, 0.0820, 0.0541, 0.0643, 0.0606, 0.0773, 0.0551, 0.0750, 0.0792, },
   [37] = {0.0820, 0.0820, 0.0524, 0.0628, 0.0606, 0.0773, 0.0551, 0.0732, 0.0777, },
   [38] = {0.0794, 0.0791, 0.0508, 0.0609, 0.0586, 0.0756, 0.0551, 0.0732, 0.0777, },
   [39] = {0.0781, 0.0776, 0.0493, 0.0592, 0.0586, 0.0756, 0.0551, 0.0714, 0.0762, },
   [40] = {0.0758, 0.0750, 0.0481, 0.0572, 0.0586, 0.0723, 0.0532, 0.0698, 0.0709, },
   [41] = {0.0735, 0.0737, 0.0470, 0.0556, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
   [42] = {0.0725, 0.0737, 0.0457, 0.0542, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
   [43] = {0.0704, 0.0713, 0.0444, 0.0528, 0.0551, 0.0693, 0.0532, 0.0667, 0.0685, },
   [44] = {0.0694, 0.0701, 0.0433, 0.0512, 0.0551, 0.0679, 0.0514, 0.0667, 0.0673, },
   [45] = {0.0676, 0.0679, 0.0421, 0.0497, 0.0551, 0.0665, 0.0514, 0.0638, 0.0651, },
   [46] = {0.0667, 0.0669, 0.0413, 0.0486, 0.0534, 0.0652, 0.0514, 0.0625, 0.0641, },
   [47] = {0.0649, 0.0659, 0.0402, 0.0474, 0.0534, 0.0639, 0.0498, 0.0625, 0.0641, },
   [48] = {0.0633, 0.0639, 0.0391, 0.0464, 0.0519, 0.0627, 0.0498, 0.0612, 0.0631, },
   [49] = {0.0625, 0.0630, 0.0382, 0.0454, 0.0519, 0.0627, 0.0498, 0.0600, 0.0621, },
   [50] = {0.0610, 0.0612, 0.0373, 0.0440, 0.0519, 0.0605, 0.0482, 0.0588, 0.0585, },
   [51] = {0.0595, 0.0604, 0.0366, 0.0431, 0.0505, 0.0594, 0.0482, 0.0577, 0.0577, },
   [52] = {0.0588, 0.0596, 0.0358, 0.0422, 0.0505, 0.0583, 0.0482, 0.0577, 0.0569, },
   [53] = {0.0575, 0.0580, 0.0350, 0.0412, 0.0491, 0.0583, 0.0467, 0.0566, 0.0561, },
   [54] = {0.0562, 0.0572, 0.0341, 0.0404, 0.0491, 0.0573, 0.0467, 0.0556, 0.0561, },
   [55] = {0.0549, 0.0557, 0.0334, 0.0394, 0.0478, 0.0554, 0.0467, 0.0545, 0.0546, },
   [56] = {0.0543, 0.0550, 0.0328, 0.0386, 0.0478, 0.0545, 0.0454, 0.0536, 0.0539, },
   [57] = {0.0532, 0.0544, 0.0321, 0.0378, 0.0466, 0.0536, 0.0454, 0.0526, 0.0531, },
   [58] = {0.0521, 0.0530, 0.0314, 0.0370, 0.0466, 0.0536, 0.0454, 0.0517, 0.0525, },
   [59] = {0.0510, 0.0524, 0.0307, 0.0364, 0.0454, 0.0528, 0.0441, 0.0517, 0.0518, },
   [60] = {0.0500, 0.0512, 0.0301, 0.0355, 0.0454, 0.0512, 0.0441, 0.0500, 0.0493, },
   [61] = {0.0469, 0.0491, 0.0297, 0.0334, 0.0443, 0.0496, 0.0435, 0.0484, 0.0478, },
   [62] = {0.0442, 0.0483, 0.0290, 0.0322, 0.0444, 0.0486, 0.0432, 0.0481, 0.0472, },
   [63] = {0.0418, 0.0472, 0.0284, 0.0307, 0.0441, 0.0470, 0.0424, 0.0470, 0.0456, },
   [64] = {0.0397, 0.0456, 0.0279, 0.0296, 0.0433, 0.0456, 0.0423, 0.0455, 0.0447, },
   [65] = {0.0377, 0.0446, 0.0273, 0.0286, 0.0426, 0.0449, 0.0422, 0.0448, 0.0438, },
   [66] = {0.0360, 0.0437, 0.0270, 0.0276, 0.0419, 0.0437, 0.0411, 0.0435, 0.0430, },
   [67] = {0.0344, 0.0425, 0.0264, 0.0268, 0.0414, 0.0427, 0.0412, 0.0436, 0.0424, },
   [68] = {0.0329, 0.0416, 0.0259, 0.0262, 0.0412, 0.0417, 0.0408, 0.0424, 0.0412, },
   [69] = {0.0315, 0.0408, 0.0254, 0.0256, 0.0410, 0.0408, 0.0404, 0.0414, 0.0406, },
   [70] = {0.0303, 0.0400, 0.0250, 0.0250, 0.0400, 0.0400, 0.0400, 0.0405, 0.0400, },
   [71] = {0.0297, 0.0393, 0.0246, 0.0244, 0.0390, 0.0392, 0.0396, 0.0396, 0.0394, },
   [72] = {0.0292, 0.0385, 0.0242, 0.0238, 0.0381, 0.0384, 0.0393, 0.0387, 0.0388, },
   [73] = {0.0287, 0.0378, 0.0238, 0.0233, 0.0372, 0.0377, 0.0389, 0.0379, 0.0383, },
}

local _apPerAgi: {ClassEnum:number} = {
    ["WARRIOR"] = 0,
    ["PALADIN"] = 0,
    ["HUNTER"] = 1,
    ["ROGUE"] = 1,
    ["PRIEST"] = 0,
    ["SHAMAN"] = 0,
    ["MAGE"] = 0,
    ["WARLOCK"] = 0,
    ["DRUID"] = 0,
};

local _rapPerAgi: {ClassEnum:number} = {
    ["WARRIOR"] = 1,
    ["PALADIN"] = 1,
    ["HUNTER"] = 1,
    ["ROGUE"] = 1,
    ["PRIEST"] = 0,
    ["SHAMAN"] = 0,
    ["MAGE"] = 0,
    ["WARLOCK"] = 0,
    ["DRUID"] = 0
};


local function getDodgeFromAgi(agi: number, class: ClassEnum, race: RaceEnum): number
    -- First determine how much Agility contributes to the player's total dodge:
    local currentLevel = UnitLevel("player");
    local currentAgi = UnitStat("player", 2);
    local dodgeRating = GetCombatRating(CR_DODGE);
    local dodgeFromRating = LB.GetEffectFromRating(dodgeRating, CR_DODGE);

    local def = {UnitDefense("player")} as {number, number};
    local totalDefense = def[1] + def[2];

    local dodgeFromDefense = (totalDefense - currentLevel * 5) * .04;
    local dodgeFromAgi = GetDodgeChance() 
        - GetStatMod("ADD_DODGE", class, race) 
        - dodgeFromRating 
        - dodgeFromDefense;

    -- Then figure out how much dodge they're getting per point of agility
    local dodgePerAgi = (dodgeFromAgi - GetBaseDodge(class)) / currentAgi;

    -- Then multiply
    return dodgePerAgi * agi;
end

local function getCritFromAgi(agi: number, class: ClassEnum, level: number): number
    local classId: number = LB.ClassNameToId[class];
    return agi * _critPerAgi[level][classId];
end

local function getAPFromAgi(agi: number, class: ClassEnum): number
    local apPerAgi: number = 0;
    if (class == "DRUID" and GetShapeshiftForm() == 2) then -- Cat form
        apPerAgi = 1;
    else
        apPerAgi = _apPerAgi[class];
    end

    return agi * apPerAgi;
end

local function getRAPFromAgi(agi: number, class: ClassEnum): number
    local rapPerAgi: number = _rapPerAgi[class];
    return agi * rapPerAgi;
end

local function getArmorFromAgi(agi: number, class: ClassEnum, race: RaceEnum): number
    local statMod = GetStatMod("MOD_ARMOR", class, race);
    local armorPerAgi = 2 * statMod;
    return agi * armorPerAgi;
end

function getBonusesString(agility: number): string
    local config = loadConfig();
    if (not config) then
        return nil;
    end

    -- First, make sure the user doesn't have everything disabled:
    if (not config["Agility-Dodge"] 
        and not config["Agility-Crit"]
        and not config["Agility-AP"]
        and not config["Agility-RAP"]
        and not config["Agility-Armor"]) then
        return nil;
    end    

    local statStrings: {string} = {};

    local playerClass = ({UnitClass("player")} as {string, ClassEnum, number})[2];
    local playerRace = ({UnitRace("player")} as {string, RaceEnum, number})[2];
    local playerLevel = UnitLevel("player");

    -- TODO: Make this toggle-able
    -- Get the amount of agility that +X agility actually grants us
    local modifiedAgility = agility * GetStatMod("MOD_AGI", playerClass, playerRace);
    modifiedAgility = math.floor(modifiedAgility);

    -- Dodge
    if (config["Agility-Dodge"]) then
        local dodgeFromAgi = getDodgeFromAgi(modifiedAgility, playerClass, playerRace);
        local dodgeString = format("%.2F", dodgeFromAgi) .. "% " .. _locale.StatStrings.Dodge;
        table.insert(statStrings, dodgeString);
    end    

    --Crit
    if (config["Agility-Crit"]) then
        local critFromAgi = getCritFromAgi(modifiedAgility, playerClass, playerLevel);
        local critString = format("%.2F", critFromAgi) .. "% " .. _locale.StatStrings.Crit;
        table.insert(statStrings, critString);
    end

    -- AP
    if (config["Agility-AP"]) then
        local apFromAgi = getAPFromAgi(modifiedAgility, playerClass);
        if (apFromAgi > 0) then            
            local apString = format("%.1F", apFromAgi).._locale.StatStrings.AttackPower;
            table.insert(statStrings, apString);
        end
    end

    -- RAP
    if(config["Agility-RAP"]) then
        local rapFromAgi = getRAPFromAgi(modifiedAgility, playerClass);
        if rapFromAgi > 0 then
            local rapString = format("%.1F", rapFromAgi).._locale.StatStrings.RangedAttackPower;
            table.insert(statStrings, rapString);
        end
    end

    -- Armor
    if(config["Agility-Armor"]) then
        local armorFromAgi = getArmorFromAgi(modifiedAgility, playerClass);
        if (armorFromAgi > 0) then
            local armorString = format("%.1F ", armorFromAgi).._locale.StatStrings.Armor;
            table.insert(statStrings, armorString);
        end
    end

    return table.concat(statStrings, ", ");
end

LB.Attributes.Agility.GetBonusesString = getBonusesString;