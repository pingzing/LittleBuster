local args = {...} as {string, SharedTable};
local LB = args[2];

-- Initialize the table so that the individial locale files can fill it
LB.LocaleTables = {};

LB.GetLocaleTable = function (locale: string): LocaleTable
    local foundLocale: LocaleTable = LB.LocaleTables[locale];
    if (not foundLocale) then
        -- Look up all the keys in the LB table, and find something with 
        -- with at least the right language and use it as the first fallback.
        -- This way even if we don't have enGB, we can try to use enUS, etc
        local localeLang: string = locale:sub(1, 2);
        for k, v in pairs(LB.LocaleTables) do
            if (LB.strStartsWith(k, localeLang)) then
                foundLocale = v;
            end
        end

        if (not foundLocale) then
            print("Little Buster is running in an unsupported locale (" .. locale ..
                      "). Falling back to enUS.");
            foundLocale = LB.LocaleTables["enUS"];
        end
    end

    return foundLocale.getLocaleTable();
end
