local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local _locale = LB.GetLocaleTable(GetLocale());
local _defaultConfig: Config = {
    ConfigVersion = "1.14.0",
    DisplayToggles = {
        ["ITEM_MOD_DEFENSE_SKILL_RATING"] = true,
        ["ITEM_MOD_DODGE_RATING"] = true,
        ["ITEM_MOD_PARRY_RATING"] = true,
        ["ITEM_MOD_BLOCK_RATING"] = true,
        ["ITEM_MOD_HIT_SPELL_RATING"] = true,
        ["ITEM_MOD_CRIT_SPELL_RATING"] = true,
        ["ITEM_MOD_HASTE_SPELL_RATING"] = true,
        ["ITEM_MOD_HIT_RATING"] = true,
        ["ITEM_MOD_CRIT_RATING"] = true,
        ["ITEM_MOD_HASTE_RATING"] = true,
        ["ITEM_MOD_EXPERTISE_RATING"] = true,
        ["ITEM_MOD_HIT_MELEE_RATING"] = true,
        ["ITEM_MOD_HIT_RANGED_RATING"] = true,
        ["ITEM_MOD_CRIT_MELEE_RATING"] = true,
        ["ITEM_MOD_CRIT_RANGED_RATING"] = true,
        ["ITEM_MOD_AGILITY"] = true,
        ["Agility-Crit"] = true,
        ["Agility-AP"] = false,
        ["Agility-RAP"] = false,
        ["Agility-Armor"] = false,
        ["Agility-Healing"] = false,
        ["ITEM_MOD_INTELLECT"] = true,
        ["Intellect-Mana"] = true,
        ["Intellect-SpellCrit"] = true,
        ["Intellect-SpellDamage"] = false,
        ["Intellect-Healing"] = false,
        ["Intellect-ManaRegen"] = false,
        ["Intellect-RangedAP"] = false,
        ["Intellect-Armor"] = false,
        ["ITEM_MOD_SPIRIT"] = true,
        ["Spirit-ManaRegenNotCasting"] = true,
        ["Spirit-ManaRegenCasting"] = false,
        ["Spirit-HealthRegen"] = true,
        ["Spirit-SpellDamage"] = false,
        ["Spirit-Healing"] = false,
        ["ITEM_MOD_STAMINA"] = true,
        ["Stamina-Health"] = true,
        ["Stamina-SpellDamage"] = false,
        ["ITEM_MOD_STRENGTH"] = true,
        ["Strength-AttackPower"] = true,
        ["Strength-BlockValue"] = false,
    }
};

-- Global Config object, stored as a SharedVariablePerCharacter.
global LB_Config: Config = nil;

-- Expose the config strings as a global so XML can see them
global LB_CONF_STR = _locale.ConfigStrings;

local _currentTogglesState: {ConfigToggle:boolean} = {
    ["ITEM_MOD_DEFENSE_SKILL_RATING"] = true,
    ["ITEM_MOD_DODGE_RATING"] = true,
    ["ITEM_MOD_PARRY_RATING"] = true,
    ["ITEM_MOD_BLOCK_RATING"] = true,
    ["ITEM_MOD_HIT_SPELL_RATING"] = true,
    ["ITEM_MOD_CRIT_SPELL_RATING"] = true,
    ["ITEM_MOD_HASTE_SPELL_RATING"] = true,
    ["ITEM_MOD_HIT_RATING"] = true,
    ["ITEM_MOD_CRIT_RATING"] = true,
    ["ITEM_MOD_HASTE_RATING"] = true,
    ["ITEM_MOD_EXPERTISE_RATING"] = true,
    ["ITEM_MOD_HIT_MELEE_RATING"] = true,
    ["ITEM_MOD_HIT_RANGED_RATING"] = true,
    ["ITEM_MOD_CRIT_MELEE_RATING"] = true,
    ["ITEM_MOD_CRIT_RANGED_RATING"] = true,
    ["ITEM_MOD_AGILITY"] = true,
    ["Agility-Dodge"] = false,
    ["Agility-Crit"] = true,
    ["Agility-AP"] = false,
    ["Agility-RAP"] = false,
    ["Agility-Armor"] = false,
    ["Agility-Healing"] = false,
    ["ITEM_MOD_INTELLECT"] = true,
    ["Intellect-Mana"] = true,
    ["Intellect-SpellCrit"] = true,
    ["Intellect-SpellDamage"] = false,
    ["Intellect-Healing"] = false,
    ["Intellect-ManaRegen"] = false,
    ["Intellect-RangedAP"] = false,
    ["Intellect-Armor"] = false,
    ["ITEM_MOD_SPIRIT"] = true,
    ["Spirit-ManaRegenNotCasting"] = true,
    ["Spirit-ManaRegenCasting"] = false,
    ["Spirit-HealthRegen"] = true,
    ["Spirit-SpellDamage"] = false,
    ["Spirit-Healing"] = false,
    ["ITEM_MOD_STAMINA"] = true,
    ["Stamina-Health"] = true,
    ["Stamina-SpellDamage"] = false,
    ["ITEM_MOD_STRENGTH"] = true,
    ["Strength-AttackPower"] = true,
    ["Strength-BlockValue"] = false,
};

local function drawCurrentState()
    -- Defenses
    LB_DefenseRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_DEFENSE_SKILL_RATING"]);
    LB_DodgeRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_DODGE_RATING"]);
    LB_ParryRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_PARRY_RATING"]);
    LB_BlockRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_BLOCK_RATING"]);

    -- Spell
    LB_SpellHitRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_HIT_SPELL_RATING"]);
    LB_SpellCritRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_CRIT_SPELL_RATING"]);
    LB_SpellHasteRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_HASTE_SPELL_RATING"]);

    -- Physicals
    LB_PhysicalHitRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_HIT_RATING"]);
    LB_PhysicalCritRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_CRIT_RATING"]);
    LB_PhysicalHasteRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_HASTE_RATING"]);
    LB_PhysicalExpertiseRatingCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_EXPERTISE_RATING"]);

    -- Attributes
    ---- Agility
    LB_AgilityCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_AGILITY"]);
    local agilityChecked = LB_AgilityCheckbox:GetChecked();
    ---- Agility sub-items
    LB_AgilityDodgeCheckbox:SetChecked(_currentTogglesState["Agility-Dodge"]);
    LB_AgilityDodgeCheckbox:SetEnabled(agilityChecked);
    LB_AgilityCritCheckbox:SetChecked(_currentTogglesState["Agility-Crit"])
    LB_AgilityCritCheckbox:SetEnabled(agilityChecked);
    LB_AgilityAPCheckbox:SetChecked(_currentTogglesState["Agility-AP"]);
    LB_AgilityAPCheckbox:SetEnabled(agilityChecked);
    LB_AgilityRAPCheckbox:SetChecked(_currentTogglesState["Agility-RAP"]);
    LB_AgilityRAPCheckbox:SetEnabled(agilityChecked);
    LB_AgilityArmorCheckbox:SetChecked(_currentTogglesState["Agility-Armor"]);
    LB_AgilityArmorCheckbox:SetEnabled(agilityChecked);
    LB_AgilityHealingCheckbox:SetChecked(_currentTogglesState["Agility-Healing"]);
    LB_AgilityHealingCheckbox:SetEnabled(agilityChecked);

    ---- Intellect
    LB_IntellectCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_INTELLECT"]);
    local intellectChecked = LB_IntellectCheckbox:GetChecked();
    ---- Intellect sub-items
    LB_IntellectManaCheckbox:SetChecked(_currentTogglesState["Intellect-Mana"]);
    LB_IntellectManaCheckbox:SetEnabled(intellectChecked);
    LB_IntellectSpellCritCheckbox:SetChecked(_currentTogglesState["Intellect-SpellCrit"]);
    LB_IntellectSpellCritCheckbox:SetEnabled(intellectChecked);
    LB_IntellectSpellDamageCheckbox:SetChecked(_currentTogglesState["Intellect-SpellDamage"]);
    LB_IntellectSpellDamageCheckbox:SetEnabled(intellectChecked);
    LB_IntellectHealingCheckbox:SetChecked(_currentTogglesState["Intellect-Healing"]);
    LB_IntellectHealingCheckbox:SetEnabled(intellectChecked);
    LB_IntellectManaRegenCheckbox:SetChecked(_currentTogglesState["Intellect-ManaRegen"]);
    LB_IntellectManaRegenCheckbox:SetEnabled(intellectChecked);
    LB_IntellectRangedAPCheckbox:SetChecked(_currentTogglesState["Intellect-RangedAP"]);
    LB_IntellectRangedAPCheckbox:SetEnabled(intellectChecked);
    LB_IntellectArmorCheckbox:SetChecked(_currentTogglesState["Intellect-Armor"]);
    LB_IntellectArmorCheckbox:SetEnabled(intellectChecked);

    --Spirit
    LB_SpiritCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_SPIRIT"]);
    local spiritChecked = LB_SpiritCheckbox:GetChecked();
    -- Spirit sub-items
    LB_SpiritManaRegenNotCastingCheckbox:SetChecked(_currentTogglesState["Spirit-ManaRegenNotCasting"]);
    LB_SpiritManaRegenNotCastingCheckbox:SetEnabled(spiritChecked);
    LB_SpiritManaRegenCastingCheckbox:SetChecked(_currentTogglesState["Spirit-ManaRegenCasting"]);
    LB_SpiritManaRegenCastingCheckbox:SetEnabled(spiritChecked);
    LB_SpiritHealthRegenCheckbox:SetChecked(_currentTogglesState["Spirit-HealthRegen"]);
    LB_SpiritHealthRegenCheckbox:SetEnabled(spiritChecked);
    LB_SpiritSpellDamageCheckbox:SetChecked(_currentTogglesState["Spirit-SpellDamage"]);
    LB_SpiritSpellDamageCheckbox:SetEnabled(spiritChecked);

    --Stamina
    LB_StaminaCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_STAMINA"]);
    local staminaChecked = LB_StaminaCheckbox:GetChecked();
    -- Stamina sub-items
    LB_StaminaHealthCheckbox:SetChecked(_currentTogglesState["Stamina-Health"]);
    LB_StaminaHealthCheckbox:SetEnabled(staminaChecked);
    LB_StaminaSpellDamageCheckbox:SetChecked(_currentTogglesState["Stamina-SpellDamage"]);
    LB_StaminaSpellDamageCheckbox:SetEnabled(staminaChecked);

    --Strength
    LB_StrengthCheckbox:SetChecked(_currentTogglesState["ITEM_MOD_STRENGTH"]);
    local strChecked = LB_StrengthCheckbox:GetChecked();
    -- Strength sub-items
    LB_StrengthAttackPowerCheckbox:SetChecked(_currentTogglesState["Strength-AttackPower"]);
    LB_StrengthAttackPowerCheckbox:SetEnabled(strChecked);
    LB_StrengthBlockValueCheckbox:SetChecked(_currentTogglesState["Strength-BlockValue"]);
    LB_StrengthBlockValueCheckbox:SetEnabled(strChecked);

end

global function LB_Config_CheckButtonChanged(_: ConfigCheckButton, statKey: ItemModKey, isChecked: boolean)
    -- TODO: Make this invalidate the caches we're storing over in the main littleBuster.tl file
    _currentTogglesState[statKey] = isChecked;
    drawCurrentState();
end

local function configFrame_OnRefresh(_: ConfigFrame)
    -- Called whenever the entire Interface panel opens, or Default is pressed
    -- Use this to init the UI.
    for k,v in pairs(LB.Config.DisplayToggles) do
        _currentTogglesState[k] = v;
    end 
    drawCurrentState();
end

local function configFrame_OnOkay(_: ConfigFrame)    
    for k,v in pairs(_currentTogglesState) do
        LB.Config.DisplayToggles[k] = v; -- in-memory across the addon
        LB_Config.DisplayToggles[k] = v; -- on disk
    end
end

local function configFrame_OnCancel(_: ConfigFrame)
    -- Set _currentTogglesState to whatever we have in LB.Config
    for k,v in pairs(LB.Config.DisplayToggles) do
        _currentTogglesState[k] = v;
    end
end

local function configFrame_OnDefault(_: ConfigFrame)    
    -- set _currentToggleState, LB_Config AND LB.Config to _defaultConfig
    for k,v in pairs(_defaultConfig.DisplayToggles) do
        _currentTogglesState[k] = v;
        LB_Config.DisplayToggles[k] = v;
        LB.Config.DisplayToggles[k] = v;
    end
    drawCurrentState();
end

local function loadCompleted(configFrame: ConfigFrame)
    configFrame.name = "Little Buster";
    configFrame.okay = configFrame_OnOkay;
    configFrame.cancel = configFrame_OnCancel;
    configFrame.refresh = configFrame_OnRefresh;
    configFrame.default = configFrame_OnDefault;

    -- Load from disk (or defaults)
    if (not LB_Config) then        
        LB_Config = _defaultConfig;
    end

    --Run through each of the default values. If we have a key that doesn't exist in LB.Config, set it to the default
    -- Top-level keys
    for k,v in pairs(_defaultConfig as {string:any}) do 
        if (LB_Config as {string:any})[k] == nil then
            (LB_Config as {string:any})[k] = v;
        end
    end

    -- Check version stuff
    local settingsVersion = LB_Config.ConfigVersion;

    -- Fix original version being stored as a number instead of a string. dur.
    if (type(settingsVersion) == "number") then
        settingsVersion = tostring(settingsVersion);
        LB_Config.ConfigVersion = settingsVersion;
    end

    -- TODO: Do stuff based on versions retrieved from disk versus what we have in the default table
    local storedVersion: {string, string} = {strsplit(".", settingsVersion)};
    local currentVersion: {string, string} = {strsplit(".", _defaultConfig.ConfigVersion)};
    if (storedVersion[1] < currentVersion[1]) then
        -- Oh no, a major version upgrade happened under our noses
    end
    if (storedVersion[2] < currentVersion[2]) then
        -- Just a minor version bump
    end

    -- Display Toggles
    for k,v in pairs(_defaultConfig.DisplayToggles) do
        if LB_Config.DisplayToggles[k] == nil then
            LB_Config.DisplayToggles[k] = v;
        end
    end
    LB.Config = LB_Config;

    InterfaceOptions_AddCategory(configFrame);
end

function LB_ConfigRootFrame_OnEvent(self: ConfigFrame, _: string, ...)
    -- Safe to assume this is ADDON_LOADED, is it's the only event we register for.
    local addonName = ... as string;
    if (addonName == "LittleBuster") then
        loadCompleted(self);    
    end    
end

function LB_ConfigRootFrame_OnLoad(self: ConfigFrame) 
    self:RegisterEvent("ADDON_LOADED");
end