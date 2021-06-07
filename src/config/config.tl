local args = {...} as {string, SharedTable};
local _: SharedTable = args[2];

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