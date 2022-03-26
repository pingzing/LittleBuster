local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

-- Initialize sub-tables to that they're ready for the individual files to fill them in.
LB.Attributes = {};
LB.Attributes.Core = {};
LB.Attributes.Agility = {};
LB.Attributes.Intellect = {};
LB.Attributes.Spirit = {};
LB.Attributes.Stamina = {};
LB.Attributes.Strength = {};

-- Many of the calculations and code in here courtesy of the original RatingBuster, and Whitetooth@Cenarius(US).

-- TODO: Can probably replace this silliness with an invocation of GetShapeshiftFormID()
local function getStanceIcon(): string
    local currentStance = GetShapeshiftForm();
    if currentStance ~= 0 then
        local stanceIcon, _, _, _ = GetShapeshiftFormInfo(currentStance);
        return stanceIcon;
    end
end

local function getPlayerBuffRank(buff: string): number
    local spellId = select(10, AuraUtil.FindAuraByName(buff, "player")) as number;
    if (spellId) then
        local rank = GetSpellSubtext(spellId);
        return rank and tonumber(string.match(rank, "(%d+)")) or 1;
    end
end

--============--
-- Base Stats --
--============--

local _raceBaseStat: {RaceEnum: {number}} = {
    ["Human"] = {20, 20, 20, 20, 21},
    ["Dwarf"] = {22, 16, 23, 19, 19},
    ["NightElf"] = {17, 25, 19, 20, 20},
    ["Gnome"] = {15, 23, 19, 24, 20},
    ["Draenei"] = {21, 17, 19, 21, 22},
    ["Orc"] = {23, 17, 22, 17, 23},
    ["Scourge"] = {19, 18, 21, 18, 25},
    ["Tauren"] = {25, 15, 22, 15, 22},
    ["Troll"] = {21, 22, 21, 16, 21},
    ["BloodElf"] = {17, 22, 18, 24, 19},
}

local _classBonusStat: {ClassEnum: {number}} = {
    ["DRUID"] = {1, 0, 0, 2, 2},
    ["HUNTER"] = {0, 3, 1, 0, 1},
    ["MAGE"] = {0, 0, 0, 3, 2},
    ["PALADIN"] = {2, 0, 2, 0, 1},
    ["PRIEST"] = {0, 0, 0, 2, 3},
    ["ROGUE"] = {1, 3, 1, 0, 0},
    ["SHAMAN"] = {1, 0, 1, 1, 2},
    ["WARLOCK"] = {0, 0, 1, 2, 2},
    ["WARRIOR"] = {3, 0, 2, 0, 0},
}

local _classBaseHealth: {ClassEnum:number} = {
    ["DRUID"] = 54,
    ["HUNTER"] = 46,
    ["MAGE"] = 52,
    ["PALADIN"] = 38,
    ["PRIEST"] = 52,
    ["ROGUE"] = 45,
    ["SHAMAN"] = 47,
    ["WARLOCK"] = 43,
    ["WARRIOR"] = 40,
}

local _classBaseMana: {ClassEnum:number} = {
    ["DRUID"] = 70,
    ["HUNTER"] = 85,
    ["MAGE"] = 120,
    ["PALADIN"] = 80,
    ["PRIEST"] = 130,
    ["ROGUE"] = 0,
    ["SHAMAN"] = 75,
    ["WARLOCK"] = 110,
    ["WARRIOR"] = 0,
}

local _classBaseDodge: {ClassEnum:number} = {
    ["WARRIOR"] = 0.7580,
    ["PALADIN"] = 0.6520,
    ["HUNTER"] = -5.4500,
    ["ROGUE"] = -0.5900,
    ["PRIEST"] = 3.1830,
    ["SHAMAN"] = 1.6750,
    ["MAGE"] = 3.4575,
    ["WARLOCK"] = 2.0350,
    ["DRUID"] = -1.8720,
}

--==================================--
-- Stat Mods from Talents and Buffs --
--==================================--
--[[ Aura mods from Thottbot
Apply Aura: Mod Total Stat % (All stats)
Apply Aura: Mod Total Stat % (Strength)
Apply Aura: Mod Total Stat % (Agility)
Apply Aura: Mod Total Stat % (Stamina)
Apply Aura: Mod Total Stat % (Intellect)
Apply Aura: Mod Total Stat % (Spirit)
Apply Aura: Mod Max Health %
Apply Aura: Reduces Attacker Chance to Hit with Melee
Apply Aura: Reduces Attacker Chance to Hit with Ranged
Apply Aura: Reduces Attacker Chance to Hit with Spells (Spells)
Apply Aura: Reduces Attacker Chance to Crit with Melee
Apply Aura: Reduces Attacker Chance to Crit with Ranged
Apply Aura: Reduces Attacker Critical Hit Damage with Melee by %
Apply Aura: Reduces Attacker Critical Hit Damage with Ranged by %
Apply Aura: Mod Dmg % (Spells)
Apply Aura: Mod Dmg % Taken (Fire, Frost)
Apply Aura: Mod Dmg % Taken (Spells)
Apply Aura: Mod Dmg % Taken (All)
Apply Aura: Mod Dmg % Taken (Physical)
Apply Aura: Mod Base Resistance % (Physical)
Apply Aura: Mod Block Percent
Apply Aura: Mod Parry Percent
Apply Aura: Mod Dodge Percent
Apply Aura: Mod Shield Block %
Apply Aura: Mod Detect
Apply Aura: Mod Skill Talent (Defense)
--]]
--[[ StatModAuras, only includes the following:

"MOD_STR",
"MOD_AGI",
"MOD_STA",
"MOD_INT",
"MOD_SPI",
"MOD_HEALTH",
"MOD_MANA",
"MOD_ARMOR",
"MOD_BLOCK_VALUE",
"MOD_DMG_TAKEN", school,
"MOD_CRIT_DAMAGE_TAKEN", school,
"ADD_DODGE",
"ADD_HIT_TAKEN", school,
"ADD_CRIT_TAKEN", school,

--Talents
"ADD_SPELL_DMG_MOD_INT"
"ADD_HEALING_MOD_INT"
"ADD_MANA_REG_MOD_INT"
"ADD_RANGED_AP_MOD_INT"
"ADD_ARMOR_MOD_INT"
"ADD_SPELL_DMG_MOD_STA"
"ADD_SPELL_DMG_MOD_SPI"
"ADD_SPELL_DMG_MOD_AP" -- Shaman Mental Quickness
"ADD_HEALING_MOD_SPI"
"ADD_HEALING_MOD_STR"
"ADD_HEALING_MOD_AP" -- Shaman Mental Quickness
"ADD_MANA_REG_MOD_NORMAL_MANA_REG"
"MOD_AP"
"MOD_RANGED_AP"
"MOD_SPELL_DMG"
"MOD_HEALING"
--]]

local _statModInfo: {AuraModEnum:StatModAdjustment} = {
    ------------------------------------------------------------------------------
    -- initialValue: sets the initial value for the stat mod
    -- if initialValue == 0, inter-mod operations are done with addition,
    -- if initialValue == 1, inter-mod operations are done with multiplication,
    ------------------------------------------------------------------------------
    -- finalAdjust: added to the final result before returning,
    -- so we can adjust the return value to be used in addition or multiplication
    -- for addition: initialValue + finalAdjust = 0
    -- for multiplication: initialValue + finalAdjust = 1
    ------------------------------------------------------------------------------
    ["ADD_DODGE"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_SPELL_DMG_MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_HEALING_MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_MANA_REG_MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_RANGED_AP_MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_ARMOR_MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_SPELL_DMG_MOD_STA"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_SPELL_DMG_MOD_SPI"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_SPELL_DMG_MOD_AP"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_HEALING_MOD_SPI"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_HEALING_MOD_STR"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_HEALING_MOD_AGI"] = { -- Nurturing Instinct
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_HEALING_MOD_AP"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
        initialValue = 0,
        finalAdjust = 0,
    },
    ["MOD_ARMOR"] = {
        initialValue = 1,
        finalAdjust = 0,
    },
    ["MOD_HEALTH"] = {
        initialValue = 1,
        finalAdjust = 0,
    },
    ["MOD_MANA"] = {
        initialValue = 1,
        finalAdjust = 0,
    },
    ["MOD_STR"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_AGI"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_STA"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_INT"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_SPI"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_BLOCK_VALUE"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_AP"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_RANGED_AP"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_SPELL_DMG"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
    ["MOD_HEALING"] = {
        initialValue = 0,
        finalAdjust = 1,
    },
}

------------------
-- StatModTable --
------------------
-- Mods that apply to specific classes only (talents, stances and self-buffs, mostly).
local _classStatModTable: {ClassEnum:{AuraModEnum:{number:StatModDetails}}} = {
    ["DRUID"] = {
        -- Druid: Lunar Guidance (Rank 3) - 1,12
        --        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
        ["ADD_SPELL_DMG_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 12,
                ["rank"] = {
                    0.08, 0.16, 0.25,
                },
            },
        },
        -- Druid: Lunar Guidance (Rank 3) - 1,12
        --        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
        ["ADD_HEALING_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 12,
                ["rank"] = {
                    0.08, 0.16, 0.25,
                },
            },
        },
        -- Druid: Nurturing Instinct (Rank 2) - 2,14        
        -- 2.4.0 Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
        ["ADD_HEALING_MOD_AGI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 14,
                ["rank"] = {
                    0.5, 1,
                },
            },
        },
        -- Druid: Intensity (Rank 3) - 3,6
        --        Allows 5%/10%/15% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
        -- 2.3.0 increased to 10/20/30% mana regeneration.
        ["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 6,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Druid: Dreamstate (Rank 3) - 1,17
        --        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
        ["ADD_MANA_REG_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 17,
                ["rank"] = {
                    0.04, 0.07, 0.10,
                },
            },
        },
        -- Druid: Feral Swiftness (Rank 2) - 2,6
        --        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
        ["ADD_DODGE"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 6,
                ["rank"] = {
                    2, 4,
                },
                ["buff"] = GetSpellInfo(32357),        -- ["Bear Form"],
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 6,
                ["rank"] = {
                    2, 4,
                },
                ["buff"] = GetSpellInfo(9634),        -- ["Dire Bear Form"],
            },
            [3] = {
                ["tab"] = 2,
                ["num"] = 6,
                ["rank"] = {
                    2, 4,
                },
                ["buff"] = GetSpellInfo(32356),        -- ["Cat Form"],
            },
        },
        -- Druid: Thick Hide (Rank 3) - 2,5
        --        Increases your Armor contribution from items by 4%/7%/10%.
        -- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
        --        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
        -- Druid: Dire Bear Form - Buff
        --        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
        -- Druid: Moonkin Form - Buff
        --        While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.
        ["MOD_ARMOR"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 5,
                ["rank"] = {
                    1.04, 1.07, 1.1,
                },
            },
            [2] = {
                ["rank"] = {
                    2.8,
                },
                ["buff"] = GetSpellInfo(32357),        -- ["Bear Form"],
            },
            [3] = {
                ["rank"] = {
                    5,
                },
                ["buff"] = GetSpellInfo(9634),        -- ["Dire Bear Form"],
            },
            [4] = {
                ["rank"] = {
                    5,
                },
                ["buff"] = GetSpellInfo(24858),        -- ["Moonkin Form"],
            },
        },
        -- Druid: Heart of the Wild (Rank 5) - 2,15
        --        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
        -- Druid: Bear Form - Stance (use stance because bear and dire bear increases are the same)
        --        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
        -- Druid: Dire Bear Form - Stance (use stance because bear and dire bear increases are the same)
        --        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        ["MOD_STA"] = { -- Heart of the Wild: +4%/8%/12%/16%/20% stamina in bear / dire bear
            [1] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.04, 0.08, 0.12, 0.16, 0.2,
                },
                ["buff"] = GetSpellInfo(32357),        -- ["Bear Form"],
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.04, 0.08, 0.12, 0.16, 0.2,
                },
                ["buff"] = GetSpellInfo(9634),        -- ["Dire Bear Form"],
            },
            [3] = { -- Survival of the Fittest: +1%/2%/3% all stats
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.01, 0.02, 0.03,
                },
            },
            [4] = { -- Bear Form / Dire Bear Form: +25% stamina
                ["rank"] = {
                    0.25,
                },
                ["buff"] = GetSpellInfo(32357),        -- ["Bear Form"],
            },
            [5] = { -- Bear Form / Dire Bear Form: +25% stamina
                ["rank"] = {
                    0.25,
                },
                ["buff"] = GetSpellInfo(9634),        -- ["Dire Bear Form"],
            },
        },        
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        ["MOD_STR"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.01, 0.02, 0.03,
                },
            },
        },
        -- Druid: Heart of the Wild (Rank 5) - 2,15
        --        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
        -- 2.3.0 This talent no longer provides 4/8/12/16/20% bonus Strength in Cat Form. Instead it provides 2/4/6/8/10% bonus attack power.
        ["MOD_AP"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
                ["buff"] = GetSpellInfo(32356),        -- ["Cat Form"],
            },
        },
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        ["MOD_AGI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.01, 0.02, 0.03,
                },
            },
        },
        -- Druid: Heart of the Wild (Rank 5) - 2,15
        --        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        ["MOD_INT"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.04, 0.08, 0.12, 0.16, 0.2,
                },
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.01, 0.02, 0.03,
                },
            },
        },
        -- Druid: Living Spirit (Rank 3) - 3,16
        --        Increases your total Spirit by 5%/10%/15%.
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        ["MOD_SPI"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 16,
                ["rank"] = {
                    0.05, 0.1, 0.15,
                },
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.01, 0.02, 0.03,
                },
            },
        },
    },
    ["HUNTER"] = {
        -- Hunter: Aspect of the Viper - Buff
        --         The hunter takes on the aspects of a viper, regenerating mana equal to 25% of his Intellect every 5 sec.
        -- TODO: Gronnstalker's Armor, (2) Set: Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
        -- 2.2.0: Aspect of the Viper: This ability has received a slight redesign. The
        -- amount of mana regained will increase as the Hunters percentage of 
        -- mana remaining decreases. At about 60% mana, it is equivalent to the
        -- previous version of Aspect of the Viper. Below that margin, it is 
        -- better (up to twice as much mana as the old version); while above 
        -- that margin, it will be less effective. The mana regained never drops
        -- below 10% of intellect every 5 sec. or goes above 50% of intellect 
        -- every 5 sec. 
        ["ADD_MANA_REG_MOD_INT"] = {
            [1] = {
                ["rank"] = {
                    0.25,
                },
                ["buff"] = GetSpellInfo(34074),            -- ["Aspect of the Viper"],
            },
        },
        -- Hunter: Careful Aim (Rank 3) - 2,16
        --         Increases your ranged attack power by an amount equal to 15%/30%/45% of your total Intellect.
        ["ADD_RANGED_AP_MOD_INT"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.15, 0.30, 0.45,
                },
            },
        },
        -- Hunter: Survival Instincts (Rank 2) - 3,14
        --         Reduces all damage taken by 2%/4%.
        -- 2.1.0 "Survival Instincts" now also increase attack power by 2/4%.
        ["MOD_AP"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 14,
                ["rank"] = {
                    0.02, 0.04,
                }
            },
        },
        -- Hunter: Master Marksman (Rank 5) - 2,19
        --         Increases your ranged attack power by 2%/4%/6%/8%/10%.
        ["MOD_RANGED_AP"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 19,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Hunter: Thick Hide (Rank 3) - 1,5
        --         Increases the armor rating of your pets by 20% and your armor contribution from items by 4%/7%/10%.
        ["MOD_ARMOR"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 5,
                ["rank"] = {
                    1.04, 1.07, 1.1,
                },
            },
        },
        -- Hunter: Survivalist (Rank 5) - 3,9
        --         Increases total health by 2%/4%/6%/8%/10%.
        -- Hunter: Endurance Training (Rank 5) - 1,2
        --         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
        ["MOD_HEALTH"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 9,
                ["rank"] = {
                    1.02, 1.04, 1.06, 1.08, 1.1,
                },
            },
            [2] = {
                ["tab"] = 1,
                ["num"] = 2,
                ["rank"] = {
                    1.01, 1.02, 1.03, 1.04, 1.05,
                },
            },
        },
        -- Hunter: Combat Experience (Rank 2) - 2,14
        --         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
        -- Hunter: Lightning Reflexes (Rank 5) - 3,18
        --         Increases your Agility by 3%/6%/9%/12%/15%.
        ["MOD_AGI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 14,
                ["rank"] = {
                    0.01, 0.02,
                },
            },
            [2] = {
                ["tab"] = 3,
                ["num"] = 18,
                ["rank"] = {
                    0.03, 0.06, 0.09, 0.12, 0.15,
                },
            },
        },
        -- Hunter: Combat Experience (Rank 2) - 2,14
        --         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
        ["MOD_INT"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 14,
                ["rank"] = {
                    0.03, 0.06,
                },
            },
        },
    },
    ["MAGE"] = {
        -- Mage: Arcane Fortitude - 1,9
        --       Increases your armor by an amount equal to 50% of your Intellect.
        -- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
        ["ADD_ARMOR_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 9,
                ["rank"] = {
                    1,
                },
            },
        },
        -- Mage: Arcane Meditation (Rank 3) - 1,12
        --       Allows 5%/10%/15% of your Mana regeneration to continue while casting.
        -- 2.3.0 increased to 10/20/30% mana regeneration.
        ["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 12,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Mage: Mind Mastery (Rank 5) - 1,22
        --       Increases spell damage by up to 5%/10%/15%/20%/25% of your total Intellect.
        ["ADD_SPELL_DMG_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 22,
                ["rank"] = {
                    0.05, 0.1, 0.15, 0.2, 0.25,
                },
            },
        },
        -- Mage: Arcane Mind (Rank 5) - 1,15
        --       Increases your total Intellect by 3%/6%/9%/12%/15%.
        ["MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 15,
                ["rank"] = {
                    0.03, 0.06, 0.09, 0.12, 0.15,
                },
            },
        },
    },
    ["PALADIN"] = {
        -- Paladin: Holy Guidance (Rank 5) - 1,19
        --          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
        ["ADD_SPELL_DMG_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 19,
                ["rank"] = {
                    0.07, 0.14, 0.21, 0.28, 0.35,
                },
            },
        },
        -- Paladin: Holy Guidance (Rank 5) - 1,19
        --          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
        ["ADD_HEALING_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 19,
                ["rank"] = {
                    0.07, 0.14, 0.21, 0.28, 0.35,
                },
            },
        },
        -- Paladin: Toughness (Rank 5) - 2,5
        --          Increases your armor value from items by 2%/4%/6%/8%/10%.
        ["MOD_ARMOR"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 5,
                ["rank"] = {
                    1.02, 1.04, 1.06, 1.08, 1.1,
                },
            },
        },
        -- Paladin: Divine Strength (Rank 5) - 1,1
        --          Increases your total Strength by 2%/4%/6%/8%/10%.
        ["MOD_STR"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 1,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Paladin: Sacred Duty (Rank 2) - 2,16
        --          Increases your total Stamina by 3%/6%, reduces the cooldown of your Divine Shield spell by 60 sec and reduces the attack speed penalty by 100%.
        -- Paladin: Combat Expertise (Rank 5) - 2,21
        --          Increases your expertise by 1/2/3/4/5 and total Stamina by 2%/4%/6%/8%/10%. -- 2.3.0
        ["MOD_STA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 16,
                ["rank"] = {
                    0.03, 0.06
                },
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 21,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                }
            },
        },
        -- Paladin: Divine Intellect (Rank 5) - 1,2
        --          Increases your total Intellect by 2%/4%/6%/8%/10%.
        ["MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 2,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Paladin: Shield Specialization (Rank 3) - 2,8
        --          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
        ["MOD_BLOCK_VALUE"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 8,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
    },
    ["PRIEST"] = {
        -- Priest: Meditation (Rank 3) - 1,9
        --         Allows 5%/10%/15% of your Mana regeneration to continue while casting.
        -- 2.3.0 increased to 10/20/30% mana regeneration.
        ["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 9,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                }
            },
        },
        -- Priest: Spiritual Guidance (Rank 5) - 2,14
        --         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
        -- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
        --         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
        ["ADD_SPELL_DMG_MOD_SPI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 14,
                ["rank"] = {
                    0.05, 0.1, 0.15, 0.2, 0.25,
                },
            },
            [2] = {
                ["tab"] = 1,
                ["num"] = 15,
                ["rank"] = {
                    0.05, 0.1,
                },
                ["buff"] = GetSpellInfo(39234),        -- ["Divine Spirit"],
            },
            [3] = {
                ["tab"] = 1,
                ["num"] = 15,
                ["rank"] = {
                    0.05, 0.1,
                },
                ["buff"] = GetSpellInfo(32999),        -- ["Prayer of Spirit"],
            },
        },
        -- Priest: Spiritual Guidance (Rank 5) - 2,14
        --         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
        -- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
        --         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
        ["ADD_HEALING_MOD_SPI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 14,
                ["rank"] = {
                    0.05, 0.1, 0.15, 0.2, 0.25,
                },
            },
            [2] = {
                ["tab"] = 1,
                ["num"] = 15,
                ["rank"] = {
                    0.05, 0.1,
                },
                ["buff"] = GetSpellInfo(39234),        -- ["Divine Spirit"],
            },
            [3] = {
                ["tab"] = 1,
                ["num"] = 15,
                ["rank"] = {
                    0.05, 0.1,
                },
                ["buff"] = GetSpellInfo(32999),        -- ["Prayer of Spirit"],
            },
        },
        -- Priest: Mental Strength (Rank 5) - 1,13
        --         IIncreases your maximum Mana by 2%/4%/6%/8%/10%.
        ["MOD_MANA"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 13,
                ["rank"] = {
                    1.02, 1.04, 1.06, 1.08, 1.1,
                },
            },
        },
        -- Priest: Enlightenment (Rank 5) - 1,20
        --         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
        ["MOD_STA"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 20,
                ["rank"] = {
                    0.01, 0.02, 0.03, 0.04, 0.05,
                },
            },
        },
        -- Priest: Enlightenment (Rank 5) - 1,20
        --         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
        ["MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 20,
                ["rank"] = {
                    0.01, 0.02, 0.03, 0.04, 0.05,
                },
            },
        },
        -- Priest: Enlightenment (Rank 5) - 1,20
        --         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
        -- Priest: Spirit of Redemption - 2,13
        --         Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.
        ["MOD_SPI"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 20,
                ["rank"] = {
                    0.01, 0.02, 0.03, 0.04, 0.05,
                },
            },
            [2] = {
                ["tab"] = 2,
                ["num"] = 13,
                ["rank"] = {
                    0.05,
                },
            },
        },
    },
    ["ROGUE"] = {
        -- Rogue: Deadliness (Rank 5) - 3,17
        --        Increases your attack power by 2%/4%/6%/8%/10%.
        ["MOD_AP"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 17,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Rogue: Lightning Reflexes (Rank 5) - 2,3
        --        Increases your Dodge chance by 1%/2%/3%/4%/5%.
        -- Rogue: Evasion (Rank 1/2) - Buff
        --        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
        -- Rogue: Ghostly Strike - Buff
        --        Dodge chance increased by 15%.
        ["ADD_DODGE"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 3,
                ["rank"] = {
                    1, 2, 3, 4, 5,
                },
            },
            [2] = {
                ["rank"] = {
                    50, 50,
                },
                ["buff"] = GetSpellInfo(26669),        -- ["Evasion"],
            },
            [3] = {
                ["rank"] = {
                    15,
                },
                ["buff"] = GetSpellInfo(31022),        -- ["Ghostly Strike"],
            },
        },
        -- Rogue: Vitality (Rank 2) - 2,20
        --        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
        -- Rogue: Sinister Calling (Rank 5) - 3,21
        --        Increases your total Agility by 3%/6%/9%/12%/15%.
        ["MOD_AGI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 20,
                ["rank"] = {
                    0.01, 0.02,
                },
            },
            [2] = {
                ["tab"] = 3,
                ["num"] = 21,
                ["rank"] = {
                    0.03, 0.06, 0.09, 0.12, 0.15,
                },
            },
        },
        -- Rogue: Vitality (Rank 2) - 2,20
        --        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
        ["MOD_STA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 20,
                ["rank"] = {
                    0.02, 0.04,
                },
            },
        },
    },
    ["SHAMAN"] = {
        -- Shaman: Mental Quickness (Rank 3) - 2,15
        --         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
        ["ADD_SPELL_DMG_MOD_AP"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Shaman: Mental Quickness (Rank 3) - 2,15
        --         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
        ["ADD_HEALING_MOD_AP"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 15,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Shaman: Unrelenting Storm (Rank 5) - 1,14
        --         Regenerate mana equal to 2%/4%/6%/8%/10% of your Intellect every 5 sec, even while casting.
        ["ADD_MANA_REG_MOD_INT"] = {
            [1] = {
                ["tab"] = 1,
                ["num"] = 14,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Shaman: Nature's Blessing (Rank 3) - 3,18
        --         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
        ["ADD_SPELL_DMG_MOD_INT"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 18,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Shaman: Nature's Blessing (Rank 3) - 3,18
        --         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
        ["ADD_HEALING_MOD_INT"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 18,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
        -- Shaman: Anticipation (Rank 5) - 2,9
        --         Increases your chance to dodge by an additional 1%/2%/3%/4%/5%.
        ["ADD_DODGE"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 9,
                ["rank"] = {
                    1, 2, 3, 4, 5,
                },
            },
        },
        -- Shaman: Toughness (Rank 5) - 2,11
        --         Increases your armor value from items by 2%/4%/6%/8%/10%.
        ["MOD_ARMOR"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 11,
                ["rank"] = {
                    1.02, 1.04, 1.06, 1.08, 1.1,
                },
            },
        },
        -- Shaman: Ancestral Knowledge (Rank 5) - 2,1
        --         Increases your maximum Mana by 1%/2%/3%/4%/5%.
        ["MOD_MANA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 1,
                ["rank"] = {
                    1.01, 1.02, 1.03, 1.04, 1.05,
                },
            },
        },
        -- Shaman: Shield Specialization 5/5 - 2,2
        --         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
        ["MOD_BLOCK_VALUE"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 2,
                ["rank"] = {
                    0.05, 0.1, 0.15, 0.2, 0.25,
                },
            },
        },
    },
    ["WARLOCK"] = {
        -- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
        --          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
        -- WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
        -- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
        ["ADD_SPELL_DMG_MOD_INT"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 20,
                ["rank"] = {
                    0.012, 0.024, 0.036,
                },
                ["condition"] = "UnitExists('pet')",
            },
        },
        -- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
        --          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
        -- WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3;
        -- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
        ["ADD_SPELL_DMG_MOD_STA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 20,
                ["rank"] = {
                    0.012, 0.024, 0.036,
                },
                ["condition"] = "UnitExists('pet')",
            },
        },
        -- Warlock: Fel Stamina (Rank 3) - 2,9
        --          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
        ["MOD_HEALTH"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 9,
                ["rank"] = {
                    1.01, 1.02, 1.03,
                },
            },
        },
        -- Warlock: Fel Intellect (Rank 3) - 2,6
        --          Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum mana by 1%/2%/3%.
        ["MOD_MANA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 6,
                ["rank"] = {
                    1.01, 1.02, 1.03,
                },
            },
        },
        -- Warlock: Demonic Embrace (Rank 5) - 2,3
        --          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
        ["MOD_STA"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 3,
                ["rank"] = {
                    0.03, 0.06, 0.09, 0.12, 0.15,
                },
            },
        },
        -- Warlock: Demonic Embrace (Rank 5) - 2,3
        --          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
        ["MOD_SPI"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 3,
                ["rank"] = {
                    -0.01, -0.02, -0.03, -0.04, -0.05,
                },
            },
        },
    },
    ["WARRIOR"] = {
        -- Warrior: Improved Berserker Stance (Rank 5) - 2,20 - Stance
        --          Increases attack power by 2%/4%/6%/8%/10% while in Berserker Stance.
        ["MOD_AP"] = {
            [1] = {
                ["tab"] = 2,
                ["num"] = 20,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
                ["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
            },
        },
        -- Warrior: Toughness (Rank 5) - 3,5
        --          Increases your armor value from items by 2%/4%/6%/8%/10%.
        ["MOD_ARMOR"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 5,
                ["rank"] = {
                    1.02, 1.04, 1.06, 1.08, 1.1,
                },
            },
        },
        -- Warrior: Vitality (Rank 5) - 3,21
        --          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
        ["MOD_STA"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 21,
                ["rank"] = {
                    0.01, 0.02, 0.03, 0.04, 0.05,
                },
            },
        },
        -- Warrior: Vitality (Rank 5) - 3,21
        --          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
        ["MOD_STR"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 21,
                ["rank"] = {
                    0.02, 0.04, 0.06, 0.08, 0.1,
                },
            },
        },
        -- Warrior: Shield Mastery (Rank 3) - 3,16
        --          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
        ["MOD_BLOCK_VALUE"] = {
            [1] = {
                ["tab"] = 3,
                ["num"] = 16,
                ["rank"] = {
                    0.1, 0.2, 0.3,
                },
            },
        },
    }
}

-- Mods that can apply to any class (buffs, mostly).
local _allStatModTable: {AuraModEnum:{number:StatModDetails}} = {
    -- Priest: Power Infusion - Buff
    --         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
    ["MOD_SPELL_DMG"] = {
        [1] = {
            ["rank"] = {
                0.2,
            },
            ["buff"] = GetSpellInfo(37274),        -- ["Power Infusion"],
        },
    },
    -- Priest: Power Infusion - Buff
    --         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
    ["MOD_HEALING"] = {
        [1] = {
            ["rank"] = {
                0.2,
            },
            ["buff"] = GetSpellInfo(37274),        -- ["Power Infusion"],
        },
    },
    -- Night Elf : Quickness - Racial
    --             Dodge chance increased by 1%.
    ["ADD_DODGE"] = {
        [1] = {
            ["rank"] = {
                1,
            },
            ["race"] = "NightElf",
        },
    },
    -- Paladin: Lay on Hands (Rank 1/2) - Buff
    --          Armor increased by 15%/30%.
    -- Priest: Inspiration (Rank 1/2/3) - Buff
    --         Increases armor by 8%/16%/25%.
    -- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
    --         Increases your armor value by 8%/16%/25%.
    ["MOD_ARMOR"] = {
        [1] = {
            ["rank"] = {
                1.15, 1.30,
            },
            ["buff"] = GetSpellInfo(27154),        -- ["Lay on Hands"],
        },
        [2] = {
            ["rank"] = {
                1.08, 1.16, 1.25,
            },
            ["buff"] = GetSpellInfo(15363),        -- ["Inspiration"],
        },
        [3] = {
            ["rank"] = {
                1.08, 1.16, 1.25,
            },
            ["buff"] = GetSpellInfo(16237),        -- ["Ancestral Fortitude"],
        },
    },
    -- Tauren: Endurance - Racial
    --         Total Health increased by 5%.
    ["MOD_HEALTH"] = {
        [1] = {
            ["rank"] = {
                1.05,
            },
            ["race"] = "Tauren",
        },
    },
    -- Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Greater Blessing of Kings - Buff
    -- Increases stats by 10%.
    ["MOD_STR"] = {
        [1] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(20217),        -- ["Blessing of Kings"],
        },
        [2] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(25898),        -- ["Greater Blessing of Kings"],
        },
    },
    -- Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Greater Blessing of Kings - Buff
    -- Increases stats by 10%.
    ["MOD_AGI"] = {
        [1] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(20217),        -- ["Blessing of Kings"],
        },
        [2] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(25898),        -- ["Greater Blessing of Kings"],
        },
    },
    -- Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Greater Blessing of Kings - Buff
    -- Increases stats by 10%.
    ["MOD_STA"] = {
        [1] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(20217),        -- ["Blessing of Kings"],
        },
        [2] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(25898),        -- ["Greater Blessing of Kings"],
        },
    },
    -- Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Greater Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Gnome: Expansive Mind - Racial
    --        Increase Intelligence by 5%.
    ["MOD_INT"] = {
        [1] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(20217),        -- ["Blessing of Kings"],
        },
        [2] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(25898),        -- ["Greater Blessing of Kings"],
        },
        [3] = {
            ["rank"] = {
                0.05,
            },
            ["race"] = "Gnome",
        },
    },
    -- Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Greater Blessing of Kings - Buff
    -- Increases stats by 10%.
    -- Human: The Human Spirit - Racial
    --        Increase Spirit by 10%.
    ["MOD_SPI"] = {
        [1] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(20217),        -- ["Blessing of Kings"],
        },
        [2] = {
            ["rank"] = {
                0.1,
            },
            ["buff"] = GetSpellInfo(25898),        -- ["Greater Blessing of Kings"],
        },
        [3] = {
            ["rank"] = {
                0.1,
            },
            ["race"] = "Human",
        },
    },
}

-- TODO: Need to make Teal happy with all my usages of GetSpellInfo() and tabley things.

local function adjustStatModifier(statModInfo: StatModAdjustment, race: RaceEnum, table: {number:StatModDetails}, modifier: number): number
    for _, case in pairs(table) do
        local ok = true;
        -- Working around Teal struggling with Global function return values that are tuples.
        local buffName: string = nil;
        if (case.buff) then
            buffName = case.buff as string; -- Taking advantage of the fact that arg 1 is a string
        end
        if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
        if ok and case.buff and not AuraUtil.FindAuraByName(buffName, "player") then ok = nil end
        if ok and case.stance and case.stance ~= getStanceIcon() then ok = nil end
        if ok and case.race and case.race ~= race then ok = nil end
        if ok then
            local rank: number;
             -- If we're looking at a talent:
             if case.tab and case.num then
                local talentInfo = {GetTalentInfo(case.tab, case.num)} as {string, number, number, number, number, number, number, number};
                rank = talentInfo[5];
            -- No talent, but we have a buff:
            elseif case.buff then
                rank = getPlayerBuffRank(buffName);
            -- no talent but all other given conditions are satisfied
            elseif case.condition or case.stance or case.race then
                rank = 1;
            end
            if rank and rank ~= 0 and case.rank[rank] then
                if statModInfo.initialValue == 0 then
                    modifier = modifier + case.rank[rank];
                else
                    modifier = modifier * case.rank[rank];
                end
            end
        end
    end
    
    return modifier;
end

local _config: {ConfigToggle : boolean};
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
LB.Attributes.Core.LoadConfig = loadConfig;

-- Gets all current talents and buffs and returns the current modifier for the player
-- for the given stat for the given class and race.
local function getStatMod(stat: AuraModEnum, class: ClassEnum, race: RaceEnum): number    
    local statModInfo: StatModAdjustment = _statModInfo[stat];
    local mod = statModInfo.initialValue;    
    -- Class specific mods
    if type(_classStatModTable[class][stat]) == "table" then
        local talentModDetails = _classStatModTable[class][stat];
        mod = adjustStatModifier(statModInfo, race, talentModDetails, mod);
    end
    -- Non class specific mods
    if type(_allStatModTable[stat]) == "table" then
        local allModDetails = _allStatModTable[stat];
        mod = adjustStatModifier(statModInfo, race, allModDetails, mod);
    end

    return mod + statModInfo.finalAdjust
end
LB.Attributes.Core.GetStatMod = getStatMod;

local function getBaseDodge(class: ClassEnum): number
    return _classBaseDodge[class];
end
LB.Attributes.Core.GetBaseDodge = getBaseDodge;

-- Returns a whole number, unless the value is less than 1 and greater than 0. Then it returns 0.x.
local function decimalFormat(value: number): string
    if (value > 0 and value < 1) then
        return format("%.1F", value);
    else
        return format("%d", value);
    end
end
LB.Attributes.Core.DecimalFormat = decimalFormat;

local function getAttributeTable(stat: ItemModKey): AttributeTable
    if stat == "ITEM_MOD_AGILITY" then
        return LB.Attributes.Agility;
    end
    if stat == "ITEM_MOD_INTELLECT" then
        return LB.Attributes.Intellect;
    end
    if stat == "ITEM_MOD_SPIRIT" then
        return LB.Attributes.Spirit;
    end
    if stat == "ITEM_MOD_STAMINA" then
        return LB.Attributes.Stamina;
    end
    if stat == "ITEM_MOD_STRENGTH" then
        return LB.Attributes.Strength;
    end
end
LB.Attributes.GetAttributeTable = getAttributeTable;