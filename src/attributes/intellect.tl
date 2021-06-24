local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];
local _config: {ConfigToggle: boolean} = nil;
local _locale = LB.GetLocaleTable(GetLocale());

local GetStatMod = LB.Attributes.Core.GetStatMod;

-- Many of the calculations, tables, values, etc, in here courtesy of StatLogic, and Whitetooth@Cenarius(US).

local _spellCritPerInt: {number: {number:number}} = {
  -- Lvl   Warr     Pala    Hunt    Rog     Pri     Sham    Warl    Mage    Dru
    [1] = {0.0000, 0.0832, 0.0699, 0.0000, 0.1710, 0.1333, 0.1637, 0.1500, 0.1431, },
    [2] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1636, 0.1272, 0.1574, 0.1435, 0.1369, },
    [3] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1568, 0.1217, 0.1516, 0.1375, 0.1312, },
    [4] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1505, 0.1217, 0.1411, 0.1320, 0.1259, },
    [5] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1394, 0.1166, 0.1364, 0.1269, 0.1211, },
    [6] = {0.0000, 0.0724, 0.0608, 0.0000, 0.1344, 0.1120, 0.1320, 0.1222, 0.1166, },
    [7] = {0.0000, 0.0694, 0.0608, 0.0000, 0.1297, 0.1077, 0.1279, 0.1179, 0.1124, },
    [8] = {0.0000, 0.0694, 0.0583, 0.0000, 0.1254, 0.1037, 0.1240, 0.1138, 0.1124, },
    [9] = {0.0000, 0.0666, 0.0583, 0.0000, 0.1214, 0.1000, 0.1169, 0.1100, 0.1086, },
   [10] = {0.0000, 0.0666, 0.0559, 0.0000, 0.1140, 0.1000, 0.1137, 0.1065, 0.0984, },
   [11] = {0.0000, 0.0640, 0.0559, 0.0000, 0.1045, 0.0933, 0.1049, 0.0971, 0.0926, },
   [12] = {0.0000, 0.0616, 0.0538, 0.0000, 0.0941, 0.0875, 0.0930, 0.0892, 0.0851, },
   [13] = {0.0000, 0.0594, 0.0499, 0.0000, 0.0875, 0.0800, 0.0871, 0.0825, 0.0807, },
   [14] = {0.0000, 0.0574, 0.0499, 0.0000, 0.0784, 0.0756, 0.0731, 0.0767, 0.0750, },
   [15] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0724, 0.0700, 0.0671, 0.0717, 0.0684, },
   [16] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0684, 0.0666, 0.0639, 0.0688, 0.0656, },
   [17] = {0.0000, 0.0520, 0.0451, 0.0000, 0.0627, 0.0636, 0.0602, 0.0635, 0.0617, },
   [18] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0597, 0.0596, 0.0568, 0.0600, 0.0594, },
   [19] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0562, 0.0571, 0.0538, 0.0569, 0.0562, },
   [20] = {0.0000, 0.0462, 0.0399, 0.0000, 0.0523, 0.0538, 0.0505, 0.0541, 0.0516, },
   [21] = {0.0000, 0.0450, 0.0388, 0.0000, 0.0502, 0.0518, 0.0487, 0.0516, 0.0500, },
   [22] = {0.0000, 0.0438, 0.0388, 0.0000, 0.0470, 0.0500, 0.0460, 0.0493, 0.0477, },
   [23] = {0.0000, 0.0427, 0.0368, 0.0000, 0.0453, 0.0474, 0.0445, 0.0471, 0.0463, },
   [24] = {0.0000, 0.0416, 0.0358, 0.0000, 0.0428, 0.0459, 0.0422, 0.0446, 0.0437, },
   [25] = {0.0000, 0.0396, 0.0350, 0.0000, 0.0409, 0.0437, 0.0405, 0.0429, 0.0420, },
   [26] = {0.0000, 0.0387, 0.0341, 0.0000, 0.0392, 0.0424, 0.0390, 0.0418, 0.0409, },
   [27] = {0.0000, 0.0387, 0.0333, 0.0000, 0.0376, 0.0412, 0.0372, 0.0398, 0.0394, },
   [28] = {0.0000, 0.0370, 0.0325, 0.0000, 0.0362, 0.0394, 0.0338, 0.0384, 0.0384, },
   [29] = {0.0000, 0.0362, 0.0318, 0.0000, 0.0348, 0.0383, 0.0325, 0.0367, 0.0366, },
   [30] = {0.0000, 0.0347, 0.0304, 0.0000, 0.0333, 0.0368, 0.0312, 0.0355, 0.0346, },
   [31] = {0.0000, 0.0340, 0.0297, 0.0000, 0.0322, 0.0354, 0.0305, 0.0347, 0.0339, },
   [32] = {0.0000, 0.0333, 0.0297, 0.0000, 0.0311, 0.0346, 0.0294, 0.0333, 0.0325, },
   [33] = {0.0000, 0.0326, 0.0285, 0.0000, 0.0301, 0.0333, 0.0286, 0.0324, 0.0318, },
   [34] = {0.0000, 0.0320, 0.0280, 0.0000, 0.0289, 0.0325, 0.0278, 0.0311, 0.0309, },
   [35] = {0.0000, 0.0308, 0.0269, 0.0000, 0.0281, 0.0314, 0.0269, 0.0303, 0.0297, },
   [36] = {0.0000, 0.0303, 0.0264, 0.0000, 0.0273, 0.0304, 0.0262, 0.0295, 0.0292, },
   [37] = {0.0000, 0.0297, 0.0264, 0.0000, 0.0263, 0.0298, 0.0254, 0.0284, 0.0284, },
   [38] = {0.0000, 0.0287, 0.0254, 0.0000, 0.0256, 0.0289, 0.0248, 0.0277, 0.0276, },
   [39] = {0.0000, 0.0282, 0.0250, 0.0000, 0.0249, 0.0283, 0.0241, 0.0268, 0.0269, },
   [40] = {0.0000, 0.0273, 0.0241, 0.0000, 0.0241, 0.0272, 0.0235, 0.0262, 0.0256, },
   [41] = {0.0000, 0.0268, 0.0237, 0.0000, 0.0235, 0.0267, 0.0230, 0.0256, 0.0252, },
   [42] = {0.0000, 0.0264, 0.0237, 0.0000, 0.0228, 0.0262, 0.0215, 0.0248, 0.0244, },
   [43] = {0.0000, 0.0256, 0.0229, 0.0000, 0.0223, 0.0254, 0.0211, 0.0243, 0.0240, },
   [44] = {0.0000, 0.0256, 0.0225, 0.0000, 0.0216, 0.0248, 0.0206, 0.0236, 0.0233, },
   [45] = {0.0000, 0.0248, 0.0218, 0.0000, 0.0210, 0.0241, 0.0201, 0.0229, 0.0228, },
   [46] = {0.0000, 0.0245, 0.0215, 0.0000, 0.0206, 0.0235, 0.0197, 0.0224, 0.0223, },
   [47] = {0.0000, 0.0238, 0.0212, 0.0000, 0.0200, 0.0231, 0.0192, 0.0220, 0.0219, },
   [48] = {0.0000, 0.0231, 0.0206, 0.0000, 0.0196, 0.0226, 0.0188, 0.0214, 0.0214, },
   [49] = {0.0000, 0.0228, 0.0203, 0.0000, 0.0191, 0.0220, 0.0184, 0.0209, 0.0209, },
   [50] = {0.0000, 0.0222, 0.0197, 0.0000, 0.0186, 0.0215, 0.0179, 0.0204, 0.0202, },
   [51] = {0.0000, 0.0219, 0.0194, 0.0000, 0.0183, 0.0210, 0.0176, 0.0200, 0.0198, },
   [52] = {0.0000, 0.0216, 0.0192, 0.0000, 0.0178, 0.0207, 0.0173, 0.0195, 0.0193, },
   [53] = {0.0000, 0.0211, 0.0186, 0.0000, 0.0175, 0.0201, 0.0170, 0.0191, 0.0191, },
   [54] = {0.0000, 0.0208, 0.0184, 0.0000, 0.0171, 0.0199, 0.0166, 0.0186, 0.0186, },
   [55] = {0.0000, 0.0203, 0.0179, 0.0000, 0.0166, 0.0193, 0.0162, 0.0182, 0.0182, },
   [56] = {0.0000, 0.0201, 0.0177, 0.0000, 0.0164, 0.0190, 0.0154, 0.0179, 0.0179, },
   [57] = {0.0000, 0.0198, 0.0175, 0.0000, 0.0160, 0.0187, 0.0151, 0.0176, 0.0176, },
   [58] = {0.0000, 0.0191, 0.0170, 0.0000, 0.0157, 0.0182, 0.0149, 0.0172, 0.0173, },
   [59] = {0.0000, 0.0189, 0.0168, 0.0000, 0.0154, 0.0179, 0.0146, 0.0168, 0.0169, },
   [60] = {0.0000, 0.0185, 0.0164, 0.0000, 0.0151, 0.0175, 0.0143, 0.0165, 0.0164, },
   [61] = {0.0000, 0.0157, 0.0157, 0.0000, 0.0148, 0.0164, 0.0143, 0.0159, 0.0162, },
   [62] = {0.0000, 0.0153, 0.0154, 0.0000, 0.0145, 0.0159, 0.0143, 0.0154, 0.0157, },
   [63] = {0.0000, 0.0148, 0.0150, 0.0000, 0.0143, 0.0152, 0.0143, 0.0148, 0.0150, },
   [64] = {0.0000, 0.0143, 0.0144, 0.0000, 0.0139, 0.0147, 0.0142, 0.0143, 0.0146, },
   [65] = {0.0000, 0.0140, 0.0141, 0.0000, 0.0137, 0.0142, 0.0142, 0.0138, 0.0142, },
   [66] = {0.0000, 0.0136, 0.0137, 0.0000, 0.0134, 0.0138, 0.0138, 0.0135, 0.0137, },
   [67] = {0.0000, 0.0133, 0.0133, 0.0000, 0.0132, 0.0134, 0.0133, 0.0130, 0.0133, },
   [68] = {0.0000, 0.0131, 0.0130, 0.0000, 0.0130, 0.0131, 0.0131, 0.0127, 0.0131, },
   [69] = {0.0000, 0.0128, 0.0128, 0.0000, 0.0127, 0.0128, 0.0128, 0.0125, 0.0128, },
   [70] = {0.0000, 0.0125, 0.0125, 0.0000, 0.0125, 0.0125, 0.0125, 0.0122, 0.0125, },
   [71] = {0.0000, 0.0122, 0.0123, 0.0000, 0.0123, 0.0122, 0.0122, 0.0119, 0.0122, },
   [72] = {0.0000, 0.0120, 0.0120, 0.0000, 0.0121, 0.0120, 0.0119, 0.0116, 0.0120, },
   [73] = {0.0000, 0.0118, 0.0118, 0.0000, 0.0119, 0.0117, 0.0117, 0.0114, 0.0118, },
};

local function getManaFromInt(int: number, class: ClassEnum, race: RaceEnum): number
    local manaPerInt = 15 * GetStatMod("MOD_MANA", class, race);
    return int * manaPerInt;
end

local function getSpellCritFromInt(int: number, class: ClassEnum, level: number): number
    local classId: number = LB.ClassNameToId[class];
    return int * _spellCritPerInt[level][classId];
end

local function getSpellDamageFromtInt(int: number, class: ClassEnum, race: RaceEnum): number
    local spellDamagePerInt = GetStatMod("ADD_SPELL_DMG_MOD_INT", class, race);
    spellDamagePerInt = spellDamagePerInt * GetStatMod("MOD_SPELL_DMG", class, race); -- honestly, the only thing this REALLY does is check for Power Infusion
    return int * spellDamagePerInt;
end

local function getHealingFromInt(int: number, class: ClassEnum, race: RaceEnum): number
    local healingPerInt = GetStatMod("ADD_HEALING_MOD_INT", class, race);
    healingPerInt = healingPerInt * GetStatMod("MOD_HEALING", class, race); -- honestly, the only thing this REALLY does is check for Power Infusion
    return int * healingPerInt;
end

local function getBonusesString(intellect: number): string
    local config = LB.Attributes.Core.LoadConfig();
    if (not config) then
        return nil;
    end

    -- Make sure the user doesn't have enerything disabled:
    if (not config["Intellect-Mana"]
        and not config["Intellect-SpellCrit"]
        and not config["Intellect-SpellDamage"]
        and not config["Intellect-Healing"]) then
            return nil;
    end

    local statStrings: {string} = {}

    local playerClass = ({UnitClass("player")} as {string, ClassEnum, number})[2];
    local playerRace = ({UnitRace("player")} as {string, RaceEnum, number})[2];
    local playerLevel = UnitLevel("player");

    -- TODO: Make this toggle-able
    local modifiedInt = intellect * GetStatMod("MOD_INT", playerClass, playerRace);
    modifiedInt = math.floor(modifiedInt);

    -- Mana
    if (config["Intellect-Mana"]) then
        local manaFromInt = getManaFromInt(modifiedInt, playerClass, playerRace);
        if (manaFromInt > 0) then
            local manaString = format("%d", manaFromInt) .. " " .. _locale.StatStrings.Mana;
            table.insert(statStrings, manaString);
        end
    end

    -- Spell Crit
    if (config["Intellect-SpellCrit"]) then
        local spellCritFromInt = getSpellCritFromInt(modifiedInt, playerClass, playerLevel);
        if (spellCritFromInt > 0) then
            local spellCritString = format("%.2F", spellCritFromInt) .. "% " .. _locale.StatStrings.SpellCrit;
            table.insert(statStrings, spellCritString);
        end
    end

    -- Spell Damage
    if (config["Intellect-SpellDamage"]) then
        local spellDamageFromInt = getSpellDamageFromtInt(modifiedInt, playerClass, playerRace);
        if (spellDamageFromInt > 0) then
            local spellDamageString = format("%d", spellDamageFromInt) .. " " .. _locale.StatStrings.SpellDamage;
            table.insert(statStrings, spellDamageString);
        end
    end

    -- Healing
    if (config["Intellect-Healing"]) then
        local healingFromInt = getHealingFromInt(modifiedInt, playerClass, playerRace);
        if (healingFromInt > 0) then
            local healingString = format("%d", healingFromInt) .. " " .. _locale.StatStrings.Healing;
            table.insert(statStrings, healingString);
        end
    end

    return table.concat(statStrings, ", ");
end

LB.Attributes.Intellect.GetBonusesString = getBonusesString;