--this file is gen by script
--you can edit this file in custom part
require "Data/Model/DailyTask/DailyActivityInfo"

--lua model
module("ModuleData.DailyTaskData", package.seeall)
--lua model end

--lua functions
local l_dailyActivityTemplates = {}

function Init()

end --func end
--next--
function Logout()

end --func end
--next--
--lua functions end

--lua custom scripts
---@return DailyActivityInfo
function GetDailyActivityTemplate()
    if #l_dailyActivityTemplates<=0 then
        return Data.DailyActivityInfo.new()
    end
    return table.remove(l_dailyActivityTemplates,1)
end
---@param tem DailyActivityInfo
function ReleaseDailyActivityTemplate(tem)
    if tem==nil then
        return
    end
    tem:Reset()
    table.insert(l_dailyActivityTemplates,tem)
end
--lua custom scripts end
return ModuleData.DailyTaskData