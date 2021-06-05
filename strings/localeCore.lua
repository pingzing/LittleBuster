local addonName, LB = ...;

function LB.getLocaleTable(locale)
    local foundTable = LB[locale].getLocaleTable();
    if (not foundTable) then
        -- Todo: Make this properly fall back to language without specific locale i.e. allow enGB to fall back to any "en".
        print("Little Buster is running in an unsupported locale (" .. locale ..
                  "). Defaulting to enUS.");
        foundTable = LB["enUS"].getLocaleTable();
    end

    return foundTable;
end
