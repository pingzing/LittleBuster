local addonName, LB = ...;

function LB.GetLocaleTable(locale)
    local foundLocale = LB[locale];
    if (not foundLocale) then
        -- Look up all the keys in the LB table, and find something with 
        -- with at least the right language and use it as the first fallback.
        -- This way even if we don't have enGB, we can try to use enUS, etc
        local localeLang = locale:sub(1, 2);
        for k, v in pairs(LB) do
            if (LB.strStartsWith(k, localeLang)) then
                print("Little Buster couldn't find a localization file for '" .. locale ..
                          "', but it did find one for '" .. k .. "'. Falling back to that.");
                foundLocale = v;
            end
        end

        if (not foundLocale) then
            print("Little Buster is running in an unsupported locale (" .. locale ..
                      "). Falling back to enUS.");
            foundLocale = LB["enUS"];
        end
    end

    return foundLocale.getLocaleTable();
end
