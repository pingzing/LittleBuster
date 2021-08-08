local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];
local _config: {ConfigToggle: boolean} = nil;
local _locale = LB.GetLocaleTable(GetLocale());

local LoadConfig = LB.Attributes.Core.LoadConfig;
local GetStatMod = LB.Attributes.Core.GetStatMod;
local floor = math.floor;
local DecimalFormat = LB.Attributes.Core.DecimalFormat;

local function getHealthFromStam(stamina: number, class: ClassEnum, race: RaceEnum): number
    local healthFromStam = stamina * 10;
    local healthBonus = GetStatMod("MOD_HEALTH", class, race);
    return healthFromStam * healthBonus;
end

local function getSpellDamageFromStam(stamina: number, class: ClassEnum, race: RaceEnum): number
    -- In an ideal world, we'd be smarter about this
    -- But in TBC Classic, the ONLY thing that gives Stam -> SpellPower is the Warlock talent
    -- Demonic Knowledge.
    -- Since Warlock pets get 30% of their master's stamina, we take 30% of the Stam we're given.
    local petScaledStamina = stamina * .3;
    local spPerStam = GetStatMod("ADD_SPELL_DMG_MOD_STA", class, race);
    spPerStam = spPerStam * GetStatMod("MOD_SPELL_DMG", class, race);
    return petScaledStamina * spPerStam;
end

local function getBonusesString(stamina: number): string
    local config = LoadConfig();
    if (not config) then
        return nil;
    end

    if (not config["Stamina-Health"]
        and not config["Stamina-SpellDamage"]) then
            return nil;
    end

    local statStrings: {string} = {};

    local playerClass = ({UnitClass("player")} as {string, ClassEnum, number})[2];
    local playerRace = ({UnitRace("player")} as {string, RaceEnum, number})[2];

    -- TODO: Make this toggle-able
    local modifiedStam = stamina * GetStatMod("MOD_STA", playerClass, playerRace);
    -- Can't use BlizzRound here, as Stamina appears to use more standard behavior, i.e. 0.5 or higher gets rounded up. (WHYYYY)
    modifiedStam = floor(modifiedStam + 0.5);    

    -- Health
    if (config["Stamina-Health"]) then
        local healthFromStam = getHealthFromStam(modifiedStam, playerClass, playerRace);
        if (healthFromStam > 0) then
            local valueString = DecimalFormat(healthFromStam);
            local hpString = valueString .. " " .. _locale.StatStrings.Health;
            table.insert(statStrings, hpString);
        end
    end

    -- Spell Damage -- TODO: This should actually use the DEMON'S Stamina. Is that the same as yours?
    if (config["Stamina-SpellDamage"]) then
        local spellDamageFromStam = getSpellDamageFromStam(modifiedStam, playerClass, playerRace);
        if (spellDamageFromStam > 0) then
            local valueString = DecimalFormat(spellDamageFromStam);
            local spellDamageString = valueString .. " " .. _locale.StatStrings.SpellDamage;
            table.insert(statStrings, spellDamageString);
        end
    end

    return table.concat(statStrings, ", ");
end

LB.Attributes.Stamina.GetBonusesString = getBonusesString;