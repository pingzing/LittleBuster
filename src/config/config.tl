local args = {...} as {string, SharedTable};
local LB: SharedTable = args[2];

local _locale = LB.GetLocaleTable(GetLocale());

-- Expose the config strings as a global so XML can see them
global LB_CONF_STR = _locale.ConfigStrings;

local function configFrame_OnOkay(self: ConfigFrame)
end

local function configFrame_OnCancel(self: ConfigFrame)
end

local function configFrame_OnRefresh(self: ConfigFrame)
end

local function configFrame_OnDefault(self: ConfigFrame)
end

function LB_ConfigRootFrame_OnLoad(self: ConfigFrame)
    self.name = "Little Buster";
    self.okay = configFrame_OnOkay;
    self.cancel = configFrame_OnCancel;
    self.refresh = configFrame_OnRefresh;
    self.default = configFrame_OnDefault;

    InterfaceOptions_AddCategory(self);
end