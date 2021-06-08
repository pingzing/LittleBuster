-- WoW Globals
global function getfenv(_: number): {string:any}
end

global function UnitLevel(_: string): number
end

global function format(_: string, _: string | number): string
end

global record FontString
    GetText: function(FontString): string
    SetText: function(FontString, string)
end

global record Tooltip
    -- Returns {itemName, itemLink}
    GetItem: function(Tooltip): {string, string}
    NumLines: function(Tooltip): number
    GetName: function(Tooltip): string
end

global record ConfigFrame
    name: string
    parent: string

    -- Functions required for usage in the Addons Interface panel
    okay: function(ConfigFrame)
    refresh: function(ConfigFrame)
    cancel: function(ConfigFrame)
    default: function(ConfigFrame)

    -- Frame-y functions
    RegisterEvent: function(ConfigFrame, string)
end

-- CheckButtons as used on the Config panel
global record ConfigCheckButton
    name: string
    stat: StatKey
    SetText: function(ConfigCheckButton, string)
    GetText: function(ConfigCheckButton): string
    GetChecked: function(ConfigCheckButton): boolean
    SetChecked: function(ConfigCheckButton, boolean)
    SetEnabled: function(ConfigCheckButton, boolean): boolean
    IsEnabled: function(ConfigCheckButton):  boolean
end

global function InterfaceOptions_AddCategory(_: ConfigFrame)
end

global record GameTooltip
    HookScript: function(Tooltip, string, function(Tooltip))
end
global record ItemRefTooltip
    HookScript: function(Tooltip, string, function(Tooltip))
end
global record ShoppingTooltip1
    HookScript: function(Tooltip, string, function(Tooltip))
end
global record ShoppingTooltip2
    HookScript: function(Tooltip, string, function(Tooltip))
end

global function GetLocale(): string
end

-- Global stat IDs provided by the game
global CR_HIT_MELEE: number
global CR_HIT_RANGED: number
global CR_CRIT_MELEE: number
global CR_CRIT_RANGED: number
global CR_HASTE_MELEE: number
global CR_HASTE_RANGED: number
global CR_EXPERTISE: number
global CR_HIT_SPELL: number
global CR_CRIT_SPELL: number
global CR_HASTE_SPELL: number
global CR_DEFENSE_SKILL: number
global CR_BLOCK: number
global CR_DODGE: number
global CR_PARRY: number

global enum StatKey
    "ITEM_MOD_CRIT_SPELL_RATING"
    "ITEM_MOD_HIT_SPELL_RATING"
    "ITEM_MOD_HASTE_SPELL_RATING"
    "ITEM_MOD_CRIT_RANGED_RATING"
    "ITEM_MOD_HIT_RANGED_RATING"
    "ITEM_MOD_CRIT_MELEE_RATING"
    "ITEM_MOD_HIT_MELEE_RATING"
    "ITEM_MOD_EXPERTISE_RATING"
    "ITEM_MOD_HIT_RATING"
    "ITEM_MOD_CRIT_RATING"
    "ITEM_MOD_HASTE_RATING"
    "ITEM_MOD_DEFENSE_SKILL_RATING"
    "ITEM_MOD_BLOCK_RATING"
    "ITEM_MOD_DODGE_RATING"
    "ITEM_MOD_PARRY_RATING"
end

-- Little Buster globals

-- Locale stuff
global record LocaleTable    
    -- Stat-conversion related things
    AlternativePatterns: {string:{string}}
    GetShortStatPatterns: function(string, string): {string}
    getLocaleTable: function(): LocaleTable

    -- Config-related things
    ConfigStrings: {string:string}
end

-- Mappings stuff
global enum StatType
    "Rating"
    "Value"
end

global record StatDetailInfo
    kind: StatKey
    type: StatType
end

-- Config stuff
global record Config
    DisplayToggles: {StatKey:boolean}
end

-- Checkboxes in config.xml
global LB_DefenseRatingCheckbox: ConfigCheckButton
global LB_DodgeRatingCheckbox: ConfigCheckButton
global LB_ParryRatingCheckbox: ConfigCheckButton
global LB_BlockRatingCheckbox: ConfigCheckButton
global LB_SpellHitRatingCheckbox: ConfigCheckButton
global LB_SpellCritRatingCheckbox: ConfigCheckButton
global LB_SpellHasteRatingCheckbox: ConfigCheckButton
global LB_PhysicalHitRatingCheckbox: ConfigCheckButton
global LB_PhysicalCritRatingCheckbox: ConfigCheckButton
global LB_PhysicalHasteRatingCheckbox: ConfigCheckButton
global LB_PhysicalExpertiseRatingCheckbox: ConfigCheckButton

-- This is the type of the shared table WoW gives us as the second arg to each script file
global record SharedTable
    -- config/config.tl
    Config: Config

    -- mappings.lua
    StatDetails: {StatDetailInfo}
    ShortStatKeys: {StatKey:string}
    RatingIDToStatKey: {number:string}
    StatKeyToRatingID: {StatKey:number}
    StatKeyIsPercentage: {StatKey:boolean}

    -- statConversion.lua
    GetEffectFromRating: function(number, number): number

    -- localeCore.lua
    GetLocaleTable: function(string): LocaleTable
    LocaleTables: {string:LocaleTable}

    -- strExtensions.lua
    strStartsWith: function(string, string): boolean
end