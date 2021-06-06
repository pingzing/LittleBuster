local args = { ... };
local LB = args[2];


LB.LocaleTables = {};

LB.GetLocaleTable = function(locale)
   local foundLocale = LB.LocaleTables[locale];
   if (not foundLocale) then



      local localeLang = locale:sub(1, 2);
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

   return foundLocale.getLocaleTable()
end
