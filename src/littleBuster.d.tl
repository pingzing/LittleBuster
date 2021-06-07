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

-- Global string names
global CR_HIT_MELEE: string
global CR_HIT_RANGED: string
global CR_CRIT_MELEE: string
global CR_CRIT_RANGED: string
global CR_HASTE_MELEE: string
global CR_HASTE_RANGED: string
global CR_EXPERTISE: string
global CR_HIT_SPELL: string
global CR_CRIT_SPELL: string
global CR_HASTE_SPELL: string
global CR_DEFENSE_SKILL: string
global CR_BLOCK: string
global CR_DODGE: string
global CR_PARRY: string

-- Little Buster globals

-- Locale stuff
global record LocaleStrings
    AlternativePatterns: {string:{string}}
end

global record LocaleTable
    Strings: LocaleStrings
    GetShortStatPatterns: function(string, string): {string}
    getLocaleTable: function(): LocaleTable
end

-- Mappings stuff
global enum StatType
    "Rating"
    "Value"
end

global record StatKey
    key: string -- todo: this could probably be an enum
    type: StatType
end

-- This is the type of the shared table WoW gives us as the second arg to each script file
global record SharedTable
    -- mappings.lua
    StatKeys: {StatKey}
    ShortStatKeys: {string:string}
    ModToRating: {string:string}
    ContainsPercent: {string:boolean}

    -- statConversion.lua
    GetEffectFromRating: function(number, string): number

    -- localeCore.lua
    GetLocaleTable: function(string): LocaleTable
    LocaleTables: {string:LocaleTable}

    -- strExtensions.lua
    strStartsWith: function(string, string): boolean
end